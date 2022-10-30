//
//  TextScanner.swift
//  TaskReader
//
//  Created by Nick Gordon on 10/12/22.
//

import SwiftUI
import AVFoundation

    enum Route {
        case camera, manual
    }

@ViewBuilder
func view(for route: Route) -> some View {
    switch route {
    case.camera:
        ContentView()
    case.manual:
        ListPage()
    }
}



struct MainPage: View {
    enum Route {
        case camera, manual
    }
  
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case.camera:
            ContentView()
        case.manual:
            ListPage()
        }
    }

    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue, Color.purple]),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)                    .edgesIgnoringSafeArea(.all)
    
                
                VStack {
                    Text("What would you like to do?")
                        .font(.system(size:30))
                        .padding(.top, 100)
                    Spacer()
                    
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Test camera")
                    }
                    .frame(width: 200, height: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow, Color.white]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)                    .edgesIgnoringSafeArea(.all)
)
                    .foregroundColor(.black)


                    NavigationLink(destination: ManaualList()) {
                        Text("Test list")
                    }
                    .frame(width: 200, height: 100)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow, Color.white]),
                                                 startPoint: .topLeading,
                                                 endPoint: .bottomTrailing)                    .edgesIgnoringSafeArea(.all))
                    .foregroundColor(.black)
                    .padding(.top, 50)
                    
                    Spacer()
                    }
                }
            }
        }
        
    }
    


struct ListPage: View {
    @State var toSay = "hello nick, this is the beginnining of a great app"
//
//    func speak() {
//        let voice = AVSpeechSynthesisVoice(language: "en-US")
//        let tosay = AVSpeechUtterance(string: toSay)
//        tosay.voice = voice
//        let spk = AVSpeechSynthesizer()
//        spk.speak(tosay)
//
//
//    }
    func talk () {
        let utterance = AVSpeechUtterance(string: "Hello world")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.1
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    var body: some View {
        VStack {
            
            Text("Write list page")
            //        Text(toSay)
            Button("Play") {
                talk()
               
            }
        }
    }
    
}
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
