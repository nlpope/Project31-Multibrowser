//  File: HomeVC.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

import UIKit
import AVKit
import AVFoundation
import WebKit

class HomeVC: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    var logoLauncher: MBLogoLauncher!
    var player = AVPlayer()
    weak var activeWebView: WKWebView?
    
    
    override func viewDidLoad() { super.viewDidLoad(); playIntro() }
    
    
    deinit { logoLauncher.removeAllAVPlayerLayers() }
    
    
    func playIntro()
    {
        PersistenceManager.isFirstVisitStatus = true
        logoLauncher = MBLogoLauncher(targetVC: self)
        if PersistenceManager.retrieveFirstVisitStatus() { logoLauncher.configLogoLauncher() }
    }
    
    //-------------------------------------//
    // MARK: - NAVIGATION SETUP
    
    func setDefaultTitle() { title = "Search anything using multiple browsers at once" }
    
    
    func configNavigation()
    {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    //-------------------------------------//
    // MARK: - WEBVIEW ADDITION / SUBTRACTION
    
    @objc func addWebView()
    {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        let url = URL(string: "https://www.github.com/nlpope")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    
    @objc func deleteWebView()
    {
        guard let webView = activeWebView else { return }
        guard let index = stackView.arrangedSubviews.firstIndex(of: webView) else { return }
        
        webView.removeFromSuperview()
        if stackView.arrangedSubviews.count == 0 { setDefaultTitle() }
        else {
            var currentIndex = Int(index)
            if currentIndex == stackView.arrangedSubviews.count {
                currentIndex = stackView.arrangedSubviews.count - 1
            }
            if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                selectWebView(newSelectedWebView)
            }
        }
    }
    
    //-------------------------------------//
    // MARK: - WEBVIEW SELECTION & Delegate Methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        if webView == activeWebView { updateUI(for: webView) }
    }
    
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer)
    {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    
    func selectWebView(_ webView: WKWebView)
    {
        for view in stackView.arrangedSubviews { view.layer.borderWidth = 0 }
        activeWebView = webView
        webView.layer.borderWidth = 3
        updateUI(for: webView)
    }
    
    
    func updateUI(for webView: WKWebView) { title = webView.title; addressBar.text = webView.url?.absoluteString ?? "" }
    
    //-------------------------------------//
    // MARK: - TEXTFIELD DELEGATE METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let webView = activeWebView, let rawAddress = addressBar.text {
            var finalAddress = ""
            
            if rawAddress.contains(".com") {
                let addressWithoutHttp = rawAddress.replacingOccurrences(of: "https://", with: "")
                finalAddress = "https://" + addressWithoutHttp
            } else {
                finalAddress = "https://www.google.com/search?q=\(rawAddress)"
            }
            
            if let url = URL(string: finalAddress) { webView.load(URLRequest(url: url)) }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    //-------------------------------------//
    // MARK: - SPLIT SCREEN BEHAVIOR (HORIZONTAL VS VERTICAL STACKING)
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        if traitCollection.horizontalSizeClass == .compact { stackView.axis = .vertical }
        else { stackView.axis = .horizontal }
    }
}
