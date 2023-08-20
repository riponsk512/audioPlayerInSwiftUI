//
//  ContentView.swift
//  audioPlayer
//
//  Created by Ripon sk on 20/08/23.
//

import SwiftUI
import AVKit
import Combine
struct ContentView: View {
    @State var player:AVAudioPlayer?
    @State var isPlay = false
    @State var musicTime = 0.0
    @State var totalTime:TimeInterval = 0.0
    @State var currentTime:TimeInterval = 0.0
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing:30){
                Text("Music")
                    .font(.title)
                    .foregroundColor(.white)
                Image(systemName:  isPlay ? "pause.circle.fill":"play.circle.fill").foregroundColor(.white).font(.largeTitle)
                //pause.circle.fill
                Slider(value: Binding(get: {
                    currentTime
                }, set: { newVal in
                    seekAudio(to: newVal)
                }),in: 0...totalTime)
                    .foregroundColor(.white)
                HStack{
                    Text(timeStr(time:currentTime)).foregroundColor(.white)
                    Spacer()
                    Text(timeStr(time:totalTime))
                        .foregroundColor(.white)
                }
            }.onTapGesture {
                isPlay ? pauseAudio():playAudio()
            }
        }.onAppear{
            getUadio()
        }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
    }
    func getUadio(){
        guard let url = Bundle.main.url(forResource: "AnkhaVich", withExtension: "mp3") else{return}
        do{
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        }catch{}
    }
    func playAudio(){
        self.player?.play()
        isPlay = true
        
    }
    func pauseAudio(){
        
        self.player?.pause()
        isPlay = false
    }
    func updateProgress(){
        guard let player = player else{return}
        currentTime = player.currentTime
    }
    func seekAudio(to time:TimeInterval){
        player?.currentTime = time
    }
    func timeStr(time:TimeInterval)->String{
        let min = Int(time)/60
        let sec = Int(time)%60
        return String(format: "%02d:%02d",min,sec)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
