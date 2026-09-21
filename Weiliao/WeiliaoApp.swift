import SwiftUI
import WebKit

@main
struct WeiliaoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView: View {
    var body: some View {
        WebViewScreen(startURL: URL(string: "http://weiliao.yinghemingyu.cn:8082/ymgate.php")!)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct WebViewScreen: UIViewRepresentable {
    let startURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = preferences
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic

        // 加载失败提示（简单实现：主文档失败时弹重试）
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: startURL))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(startURL: startURL)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        let startURL: URL
        init(startURL: URL) { self.startURL = startURL }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            let alert = UIAlertController(title: "加载失败",
                                          message: "网络连接失败，请检查网络后重试。",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "重试", style: .default) { _ in
                webView.load(URLRequest(url: self.startURL))
            })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            // 找到顶层 ViewController 弹窗（兼容 iOS 14：不使用 iOS 15 才有的 keyWindow）
            var top = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })?
                .rootViewController
            while let presented = top?.presentedViewController { top = presented }
            top?.present(alert, animated: true)
        }
    }
}
