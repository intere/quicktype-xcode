import Foundation
import JavaScriptCore

enum Language: String {
    case swift, java, cpp, objc, objcHeader
}

fileprivate let languageUTIs: [CFString: Language] = [
    kUTTypeSwiftSource: .swift,
    kUTTypeObjectiveCSource: .objc,
    kUTTypeCHeader: .objc,
    kUTTypeJavaSource: .java,
    kUTTypeCPlusPlusSource: .cpp,
    kUTTypeObjectiveCPlusPlusSource: .objc,
    "com.apple.dt.playground" as CFString: .swift
]

func languageFor(contentUTI: CFString) -> Language? {
    print(contentUTI)
    for (uti, language) in languageUTIs {
        if UTTypeConformsTo(contentUTI as CFString, uti) {
            return language
        }
    }
    return nil
}

class Runtime {
    typealias QuicktypeCompletionHandler = (Result<[String], NSError>) -> Void
    public static let shared = Runtime()
    
    var context: JSContext!
    
    let preface = [
        "Generated with quicktype",
        "For more options, try https://app.quicktype.io"
    ]
    
    private init() {
    }
    
    var isInitialized: Bool {
        return nil != context
    }
    
    var _quicktypeJavaScript: String?
    var quicktypeJavaScript: String? {
        if nil == _quicktypeJavaScript {
            guard let javascriptPath = Bundle.main.url(forResource: "quicktype", withExtension: "js") else { return nil }
            guard let data = try? Data(contentsOf: javascriptPath) else { return nil }
            _quicktypeJavaScript = String(data: data, encoding: .utf8)
        }
        
        return _quicktypeJavaScript
    }
    
    func initialize() -> Bool {
        guard let context = JSContext() else { return false }
        
        context.exceptionHandler = { context, exception in
            print("JS Error: \(exception?.description ?? "unknown error")")
        }
        
        context.evaluateScript("""
            var window = {};
            var setTimeout = function(f) { f(); };
            var clearTimeout = function() {};
            var console = {};
        """)
        
        let consoleLog: @convention(block) (Any) -> Void = { print($0) }
        context.objectForKeyedSubscript("console").setObject(consoleLog, forKeyedSubscript: "log" as NSString)
        
        guard let javascript = quicktypeJavaScript else { return false }
        context.evaluateScript(javascript)
        
        self.context = context
        
        return true
    }
    
    private func resolve(resolve: @escaping ([String]) -> Void) {
        let resolveBlock: @convention(block) ([String]) -> Void = { resolve($0) }
        context.setObject(resolveBlock, forKeyedSubscript: "resolve" as NSString)
    }
    
    private func reject(reject: @escaping (String) -> Void) {
        let rejectBlock: @convention(block) (String) -> Void = { reject($0) }
        context.setObject(rejectBlock, forKeyedSubscript: "reject" as NSString)
    }
    
    func renderOptionsToJavaScriptObject(_ options: [String: Any]) -> String {
        return "{ " + options.map { key, value in
            var javaScriptValue = "\(value)"
            
            switch value {
            case is String: javaScriptValue = "\"\(value)\""
            default: break
            }
            
            return "\"\(key)\": \(javaScriptValue)"
        }.joined(separator: ", ") + " }"
    }
    
    func quicktype(
        _ json: String,
        topLevel: String,
        language: Language,
        options: [String: Any],
        completion: @escaping QuicktypeCompletionHandler
    ) {
        // .header (C header files) are assumed to be Objective-C headers
        if language == .objcHeader {
            return quicktype(json, topLevel: topLevel, language:.objc, options: options, completion: completion)
        }
        
        resolve { lines in completion(.success(lines)) }
        reject { errorMessage in completion(.failure(.quicktypeError(errorMessage))) }
        
        let comments = preface.map { "\"\($0)\"" }.joined(separator: ",")
        
        context.evaluateScript("""
            function swifttype(json) {
                window.quicktype.quicktype({
                  lang: "\(language.rawValue)",
                  sources: [{
                    kind: "json",
                    name: "\(topLevel)",
                    samples: [json]
                  }],
                  leadingComments: [\(comments)],
                  rendererOptions: \(renderOptionsToJavaScriptObject(options)),
                }).then(function(result) {
                  resolve(result.lines);
                }).catch(function(e) {
                  reject(e.toString());
                });
            }
        """)
        
        let swifttype = context.objectForKeyedSubscript("swifttype")!
        swifttype.call(withArguments: [json])
    }

    func quicktype(_ json: String, topLevel: String, language: Language, options: [String: Any]) async throws -> [String] {
        return try await withUnsafeThrowingContinuation { continuation in
            quicktype(json, topLevel: topLevel, language: language, options: options) { result in
                switch result {
                case .success(let lines):
                    continuation.resume(returning: lines)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
