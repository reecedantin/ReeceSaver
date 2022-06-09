//
//  WebView.swift
//  ReeceSaver
//
//  Created by Reece Dantin on 5/4/22.
//

import SwiftUI

struct ClockView: View {
    
    @State var name: String = ""
    @State var time: String = ""
    @State var welcome: String = ""
    @State var dateString: String = ""
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                VStack(alignment: .leading) {
                    Text(welcome)
                        .fontWeight(.ultraLight)
                        .font(.system(size: 1000))
                        .minimumScaleFactor(0.001)
                        .lineLimit(1)
                        .foregroundColor(Color(.displayP3, white: 0.8823, opacity: 1))
                        .frame(height: g.size.height*0.15)
                        .padding(.top, g.size.height*0.026)
                        .padding(.leading, g.size.width*0.026)
                        .padding(.trailing, g.size.width*0.026)
                    
                }
                .frame(minWidth: .zero, idealWidth: .infinity, maxWidth: .infinity, minHeight: .zero, idealHeight: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                
                Text(time)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.displayP3, white: 0.8823, opacity: 1))
                    .font(.system(size: 9000))
                    .minimumScaleFactor(0.01)
                    .padding(.leading, g.size.height*0.026)
                    .padding(.trailing, g.size.height*0.026)
                    .onReceive(timer) { currentTime in
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: currentTime)
                        let minute = calendar.component(.minute, from: currentTime)
                        
                        time = getTimeText(hour: hour, minute: minute)
                    }
                
                
                VStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Text(dateString)
                            .fontWeight(.thin)
                            .font(.system(size: 1000))
                            .minimumScaleFactor(0.001)
                            .lineLimit(1)
                            .foregroundColor(Color(.displayP3, white: 0.8823, opacity: 1))
                            .frame(height: g.size.height*0.11)
                            .padding(.leading, g.size.height*0.026)
                            .padding(.trailing, g.size.height*0.026)
                    }
                    .frame(height: g.size.height*0.22)
                }
                .frame(minWidth: .zero, idealWidth: .infinity, maxWidth: .infinity, minHeight: .zero, idealHeight: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
//        .frame(width: 1280, height: 720)
        .onAppear() {
            
            let defaults = UserDefaults.standard
            let storedName = defaults.string(forKey: "name") ?? ""
            name = storedName.uppercased()
            
            let currentTime = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentTime)
            let minute = calendar.component(.minute, from: currentTime)
            
            time = getTimeText(hour: hour, minute: minute)
            
            welcome = getWelcome(name: name, hour: hour)
            
            dateString = getDateString(currentTime: currentTime)
        }
    }
    
    func getWelcome(name: String, hour: Int) -> String {
        
        //current count : 32
        
        let welcomes = ["WELCOME BACK, \(name)" , "HELLO \(name)", "GOOD TO SEE YOU SIR", "HOWDY \(name)"]
        let longTime = ["HEY \(name) WHAT'S NEW?", "LONG TIME NO SEE", "WHERE HAVE YOU BEEN HIDING?", "HOW'VE YOU BEEN?"]
        let questions = ["HOW YA DOIN \(name)?", "WHATS UP \(name)?", "HEY \(name), HOWS IT GOIN?", "WHAT'S CRACKIN?", "WHAT'S GOOD?", "WHAT'S HAPPENIN?", "SUP HOMESLICE?", "WHAZAAAAP?"]
        let otherLanguage = ["ALOHA \(name)", "HOLA SEÑOR \(name)", "BONJOUR \(name)", "HALLO \(name)", "CIAO \(name)", "KONNICHIWA \(name)"]
        let affectionate = ["ELLO MATE", "HEEEY, BAAABY", "HOW YOU DOIN?", "I LIKE YOUR FACE", "HEY BOO"]
        let morning = ["TOP OF THE MORNIN TO YA", "GOOOOOD MORNING, \(name)!", "HAVE A NICE DAY", "ENJOY YOUR DAY", "GO GET EM TIGER"]


        if(hour <= 10 && hour >= 5) {
            return morning.randomElement()!
        } else if(hour == 11) {
            return otherLanguage.randomElement()!
        } else if(hour >= 12 && hour <= 15) {
            return questions.randomElement()!
        } else if(hour == 18) {
            return longTime.randomElement()!
        } else if(hour == 21) {
            return affectionate.randomElement()!
        } else {
            return welcomes.randomElement()!
        }
    }
    
    func getDateString(currentTime: Date) -> String {
        
        let days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentTime)
        let weekday = calendar.component(.weekday, from: currentTime)
        let month = calendar.component(.month, from: currentTime)
        
        let ending = ordinal_suffix(day: day)
        
        return "\(days[weekday-1]), \(months[month-1]) \(ending)"
    }
    
    func ordinal_suffix(day: Int) -> String {
        let j = day % 10
        let k = day % 100
        
        
        if (j == 1 && k != 11) {
            return "\(day)st";
        }
        if (j == 2 && k != 12) {
            return "\(day)nd";
        }
        if (j == 3 && k != 13) {
            return "\(day)rd";
        }
        return "\(day)th";
    }
    
    func getTimeText(hour: Int, minute: Int) -> String {
        var h = (hour > 12) ? hour - 12 : hour
        h = (h == 0) ? 12 : h
        let mText = (minute < 10) ? "0\(minute)" : "\(minute)"
        return "\(h):\(mText)"
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockView()
        }
    }
}
