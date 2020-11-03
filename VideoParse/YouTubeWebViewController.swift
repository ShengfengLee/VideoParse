//
//  YouTubeWebViewController.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/3/12.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import SnapKit
import AVKit

class YouTubeWebViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var titleItem: UINavigationItem!
    var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    @IBOutlet weak var gobackItem: UIBarButtonItem!
    @IBOutlet weak var refreshItem: UIBarButtonItem!
    @IBOutlet weak var moreItem: UIBarButtonItem!
    @IBOutlet weak var okBtn: UIButton!
    
    var completeHandle: ((String?, String?)->Void)?
    public var videoId: Variable<String?> = Variable(nil)


    var absoluteString: String = "https://www.youtube.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUI()
        bindUI()
        
        if let url = URL(string: absoluteString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initUI() {
//        okBtn.isHidden = true
        initWebView()
    }
    
    func initWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        config.allowsPictureInPictureMediaPlayback = false

        self.view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.naviBar.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.toolBar.snp.top)
        }
    }

    
    func bindUI() {
        webView.rx.title
        .subscribe(onNext: { [weak self] (title) in
            self?.titleItem.title = title
        })
        .disposed(by: disposeBag)
        
        webView.rx.url
            .subscribe(onNext: { [weak self] (url) in
                if let url = url {
                    self?.videoId.value = YoutubeParse.videoId(from: url)//videoIDFromYouTubeURL(url)
                }
                else {
                    self?.videoId.value = nil
                }
                
            })
            .disposed(by: disposeBag)
        
        videoId.asObservable().subscribe(onNext: { [weak self] (videoId) in
//            self?.okBtn.isHidden = (videoId == nil)
        }).disposed(by: disposeBag)
        
        webView.rx.canGoForward.subscribe(onNext: { [weak self] (canGoForward) in
            self?.forwardItem.isEnabled = canGoForward
        }).disposed(by: disposeBag)
        
        
        webView.rx.canGoBack.subscribe(onNext: { [weak self] (canGoBack) in
            self?.gobackItem.isEnabled = canGoBack
        }).disposed(by: disposeBag)
        
        webView.rx.loading.subscribe(onNext: { [weak self] (loading) in
            self?.refreshItem.isEnabled = !loading
        }).disposed(by: disposeBag)
    }

    
    // MARK: - buttons action
    @IBAction func okClick(_ sender: UIButton) {
        self.webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { [weak self] (data, error) in
            let html = data as? String
            Video.parse(url: self?.webView.url, html: html) { (entity) in
                if let absoluteString = entity?.videoResource?.absoluteString {
                    print(absoluteString)

                    DispatchQueue.main.async {  [weak self] in
                        self?.alert(absoluteString)
                    }
                }
            }
        }
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        if let navi = self.navigationController {
            navi.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func forwardClick(_ sender: Any) {
        self.webView.goForward()
    }
    
    
    @IBAction func gobackClick(_ sender: Any) {
        self.webView.goBack()
    }
    
    
    @IBAction func reloadClick(_ sender: Any) {
        self.webView.reload()
    }
    
    
    @IBAction func moreClick(_ sender: Any) {
        
    }
    

}


extension YouTubeWebViewController {

    func alert(_ url: String) {
        let alertVC = UIAlertController(title: "播放视频", message: nil, preferredStyle: .alert)

        let playAction = UIAlertAction(title: "播放", style: .default) { [weak self] (_) in
            self?.play(url)
        }
        alertVC.addAction(playAction)

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)

        self.present(alertVC, animated: true, completion: nil)

    }
    func play(_ urlstr: String) {
        guard let url = URL(string: urlstr) else { return }
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: url)
        self.present(playerVC, animated: true, completion: nil)
    }
}
