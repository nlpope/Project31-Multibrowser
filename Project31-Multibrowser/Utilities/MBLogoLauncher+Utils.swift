//  File: MBLogoLauncher+Utils.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

//  * MOVE THIS FILE TO X+UTILS
//  * ADD THE DEINIT METHOD
//  * SEE IOS NOTES CLONE FOR 'ISFIRSTVISIT' REFERENCES IN SCENEDELEGATE
//  * BE SURE 'FORRESOURCE' NAME INS CONTANTS MATCHES LAUNCHSCREEN.MP4 FILE

import UIKit
import AVKit
import AVFoundation

class MBLogoLauncher
{
    var targetVC: HomeVC!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var animationDidPause = false
    var isFirstVisit: Bool! = PersistenceManager.retrieveFirstVisitStatus() {
        didSet { PersistenceManager.save(firstVisitStatus: isFirstVisit) }
    }
    
    init(targetVC: UIViewController) { self.targetVC = targetVC as? HomeVC }
    
    
    func configLogoLauncher( )
    {
        maskHomeVCForIntro()
        configNotifications()
        
        guard let url = Bundle.main.url(forResource: VideoKeys.launchScreen, withExtension: ".mp4")
        else { return }
        
        player = AVPlayer.init(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer?.frame = targetVC.view.layer.frame
        playerLayer?.name = VideoKeys.playerLayerName
        player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch {
            print("Background noise inclusion unsuccessful")
        }
        
        player?.play()
        
        targetVC.view.layer.insertSublayer(playerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    
    func maskHomeVCForIntro()
    {
        targetVC.navigationController?.isNavigationBarHidden = true
    }
    
    
    func configNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func playerDidFinishPlaying()
    {
        isFirstVisit = false
        removeAllAVPlayerLayers()
        targetVC.navigationController?.isNavigationBarHidden = false
        // HOMEVC load func on finish
    }
    
    
    func removeAllAVPlayerLayers()
    {
        if let layers = targetVC.view.layer.sublayers {
            for (i, layer) in layers.enumerated() {
                if layer.name == VideoKeys.playerLayerName { layers[i].removeFromSuperlayer() }
            }
        }
    }
    
    
    @objc func setPlayerLayerToNil() { player?.pause(); playerLayer = nil }
    
    
    @objc func reinitializePlayerLayer()
    {
        guard isFirstVisit else { return }
        if let player = player {
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.name = VideoKeys.playerLayerName
            
            if #available(iOS 10.0, *) { if player.timeControlStatus == .paused { player.play() } }
            else { if player.isPlaying == false { player.play() } }
        }
    }
}

