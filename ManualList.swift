//
//  ManualList.swift
//  TaskReader
//
//  Created by Nick Gordon on 10/29/22.
//

import SwiftUI
import AVFoundation
import UIKit

// struct to make list. name that shows description list and positon for order.



struct Reminder: Identifiable {
    
    
    @State var name:String
    let position:Int
    let id = UUID()
    
    let talk = AVSpeechSynthesizer()
    
    func speak() {
        let speech = AVSpeechUtterance(string: self.name)
        talk.speak(speech)
    }
}

struct ManaualList: View {
    @State var taskOne = ""
    @State var taskTwo = ""
    @State var taskThree = ""
    @State var taskFour = ""
    @State var taskFive = ""
    
    let size = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.5), heightDimension: .fractionalWidth(0.5))
    
    
    @State var reminders = [
        
        Reminder(name: "User does task one", position: 1),
        Reminder(name: "User does task two", position: 2),
        Reminder(name: "User does task three", position: 3),
        Reminder(name: "User does task four", position: 4),
        Reminder(name: "User does task five ", position: 5)
        
    ]
    
    func playList() {
        var int:Double = 0
        
        for reminder in reminders {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2   * int) {
                reminder.speak()
                
                
            }
            
            int += 1
        }
    }
    
    @State var i = 0
    @State var nextButton = "What's next"
    @State var isShowingAddListScreen = false
    
    func playNext()  {
        
        
        
        if i < reminders.count  {
            reminders[i].speak()
            nextButton = "Next Task"
            i += 1
            
        }
        else {
            i = 0
            nextButton = "Play again"
        }
    }
    
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var userInputList = ""
    
    
    @State var currentDate:Date = Date()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter
        
    }
    
    var body: some View {
        ZStack {
            
            
            RadialGradient(gradient: Gradient(colors: [Color(.white), Color(.purple)]),
                           center: .center,
                           startRadius: 5,
                           endRadius: 500)
            .ignoresSafeArea()
            Group {
                VStack {
                    Text("Add")
                        .foregroundColor(.black)
                        .frame(width: 80, height: 25)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow, Color.white]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                            .edgesIgnoringSafeArea(.all))
                        .cornerRadius(15)
                        .padding(.leading, 300)
                        .onTapGesture {
                            isShowingAddListScreen = true
                        }
                    
                    
                    Text("Text to Speech")
                        .padding()
                        .font(.system(size: 40))
                    
                    
                    
                    
                    List(reminders) { reminder in
                        HStack {
                            Text(String(reminder.position))
                            Text(reminder.name)
                        }
                        .frame(height: 85)
                        
                        
                        
                        
                    }   .frame(height:550)
                        .background(.yellow)
                    
                    HStack {
                        
                        Button("Today's list") {
                            playList()
                        }
                        
                        .frame(width: 150, height: 30)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow, Color.white]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                            .edgesIgnoringSafeArea(.all))
                        .cornerRadius(15)
                        
                        Button(nextButton) {
                            playNext()
                        }
                        
                        .frame(width: 150, height: 30)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow, Color.white]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                            .edgesIgnoringSafeArea(.all))
                        .cornerRadius(15)
                        
                        
                    }
                    .foregroundColor(.black)
                    
                    
                    Text(dateFormatter.string(from: currentDate))
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .frame(width:300,height:50)
                        
                }
            }
            .onReceive(timer, perform: { value in
                currentDate = value
                
            })
        }
        
    }
    
}


struct ManualList_Previews: PreviewProvider {
    static var previews: some View {
        ManaualList()
    }
}
