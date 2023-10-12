//
//  LoopingPlayer.swift
//  VideoBySwiftUI
//
//  Created by César Manuel on 05/10/23.
//

import SwiftUI
import AVFoundation

// SwiftUI -> UIViewRepresentable (UIView -> UIKit)

// UIView -> UIViewRepresentable

//Object being interpreted by SwiftUI
struct LoopingPlayer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView{
        return QueuePlayerUIView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIView, context: Context){
        //Do nothing
    }
}

// Element UIKit:
class QueuePlayerUIView: UIView{
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //Load video:
        
        let fileUrl = Bundle.main.url(forResource: "timer", withExtension: "mov")!
        
        let playerItem = AVPlayerItem(url: fileUrl)
        
        //Setup player:
        
        let player = AVQueuePlayer(playerItem: playerItem)
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        layer.addSublayer(playerLayer)
        
        //Loop:
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        //Play:
        
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayerUIView: UIView{
    private var playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //Load video:
        
        let fileUrl = Bundle.main.url(forResource: "timer", withExtension: "mov")!
        
        let playerItem = AVPlayerItem(url: fileUrl)
        
        //Setup player:
        
        let player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        //Loop:
        
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(rewindVideo(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        player.play()
    }
    
    @objc
    func rewindVideo(notification: Notification) {
            playerLayer.player?.seek(to: .zero)
        }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

struct LoopingPlayer_Previews: PreviewProvider{
    static var previews: some View{
        LoopingPlayer()
    }
}


