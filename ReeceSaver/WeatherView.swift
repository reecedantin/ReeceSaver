//
//  WeatherView.swift
//  ReeceSaver
//
//  Created by Reece Dantin on 6/6/22.
//

import SwiftUI

struct WeatherView: View {
    
    @State var text = "Hello world"
    @State var temps: [ForcastTime] = []
    @State var currentFC: ForcastTime?
    
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            if currentFC != nil {
                                Text("\(currentFC!.temperature)º F")
                                    .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                                    .fontWeight(.thin)
                                    .font(.system(size: 1000))
                                    .minimumScaleFactor(0.001)
                                    .lineLimit(1)
                                    .padding(.top, g.size.height * 0.05)
                                    .frame(width: g.size.width*0.7, alignment: .leading)
                                
                                HStack(spacing: 0) {
                                    if currentFC!.getSFIcon() == nil {
                                        AsyncImage(
                                            url: URL(string: currentFC!.icon),
                                            content: { image in
                                                image.resizable()
                                                     .aspectRatio(contentMode: .fit)
                                                     .frame(maxHeight: g.size.height*0.075)
                                            },
                                            placeholder: {
                                                ProgressView()
                                            })
                                    } else {
                                        Image(systemName: currentFC!.getSFIcon()!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                                            .frame(maxHeight: g.size.height*0.075)
                                    }
                                    
                                    Text(currentFC!.shortForecast)
                                        .italic()
                                        .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                                        .fontWeight(.thin)
                                        .font(.system(size: 1000))
                                        .minimumScaleFactor(0.001)
                                        .padding(.leading, g.size.width * 0.015)
                                        .padding(.trailing, g.size.width * 0.015)
                                        .frame(width: g.size.width*0.4, alignment: .leading)
                                        
                                }
                                .frame(height: g.size.height*0.1)
                            }
                        }
                        .padding(.leading, g.size.width * 0.075)
                        Spacer()
                    }
                    .frame(height: g.size.height*0.55)
                    
                    Spacer()
                }
                .frame(width: g.size.width, alignment: .top)
                
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        if temps.count != 0 {
                            Rectangle()
                                .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                                .frame(width: 1)
                            ForEach(temps, id: \.self) { temp in
                                VStack {
                                    RenderTemp(temp: temp)
                                }
                                .frame(width: g.size.width * 0.157)
                                Rectangle()
                                    .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                                    .frame(width: 1)
                            }
                        }
                    }
                    .frame(height: g.size.height*0.3)
                }
                .frame(width: g.size.width)
                
            }
        }
        .onAppear() {
            let defaults = UserDefaults.standard
            let lat = defaults.string(forKey: "lat")
            let long = defaults.string(forKey: "long")
            
            if lat != nil && long != nil {
                loadPoint(lat: lat!, long: long!)
            }
        }
        
    }
    
    
    
    func loadPoint(lat: String, long: String) {
        let url = URL(string: "https://api.weather.gov/points/\(lat),\(long)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let propertiesDictionary = dictionary["properties"] as? [String: Any] {
                        let forcastURL = propertiesDictionary["forecastHourly"]
//                        print(forcastURL)
                        getForcast(url: forcastURL as! String)
                    }
                }
            }
            
        }
        task.resume()
    }
    
    func getForcast(url: String) {
        let url = URL(string: url)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let propertiesDictionary = dictionary["properties"] as? [String: Any] {
                        let forcastArray = propertiesDictionary["periods"]
                        if let forcast = forcastArray as? [[String: Any]] {
                            for temp in forcast {
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                
                                
                                let fcTemp = ForcastTime(number: temp["number"] as! Int, name: temp["name"] as! String, startTime: dateFormatter.date(from: temp["startTime"] as! String), endTime: dateFormatter.date(from: temp["endTime"] as! String), isDaytime: (temp["isDaytime"] != nil), temperature: temp["temperature"] as! Int, temperatureUnit: temp["temperatureUnit"] as! String, temperatureTrend: temp["temperatureTrend"] as? String, windSpeed: temp["windSpeed"] as! String, windDirection: temp["windDirection"] as! String, icon: temp["icon"] as! String, shortForecast: temp["shortForecast"] as! String, detailedForecast: temp["detailedForecast"] as! String)
                                

                                let now = Date()
                                
                                if fcTemp.startTime!.timeIntervalSince(now) < 0 && fcTemp.endTime!.timeIntervalSince(now) > 0 {
                                    currentFC = fcTemp
                                    print("current temp: \(fcTemp.temperature)")
                                }
                                
                                if fcTemp.startTime!.timeIntervalSince(now) < 18000 && fcTemp.startTime!.timeIntervalSince(now) > 0 {
                                    temps.append(fcTemp)
                                }
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

struct ForcastTime: Codable, Hashable {
    var number: Int
    var name: String
    var startTime: Date?
    var endTime: Date?
    var isDaytime: Bool
    var temperature: Int
    var temperatureUnit: String
    var temperatureTrend: String?
    var windSpeed: String
    var windDirection: String
    var icon: String
    var shortForecast: String
    var detailedForecast: String
    
    
    func getSFIcon() -> String? {
        
        let index = self.icon.lastIndex(of: "/")!
        let index2 = self.icon.lastIndex(of: "?")!
        
        let icon = self.icon[index..<index2]
        
        let nightTime = self.icon.contains("night")
        
        switch icon {
            case "/skc":
            //Fair/clear
                if nightTime {
                    return "moon.stars.fill"
                } else {
                    return "sun.max.fill"
                }
            case "/few":
            //A few clouds
                if nightTime {
                    return "cloud.moon.fill"
                } else {
                    return "cloud.sun.fill"
                }
            case "/sct":
            //Partly cloudy
                if nightTime {
                    return "cloud.moon.fill"
                } else {
                    return "cloud.sun.fill"
                }
            case "/bkn":
            //Mostly cloudy
                if nightTime {
                    return "cloud.moon.fill"
                } else {
                    return "cloud.sun.fill"
                }
            case "/ovc":
            //Overcast
                return "cloud.fill"
            case "/wind_skc":
            //Fair/clear and windy
                return "wind"
            case "/wind_few":
            //A few clouds and windy
                return "wind"
            case "/wind_sct":
            //Partly cloudy and windy
                return "wind"
            case "/wind_bkn":
            //Mostly cloudy and windy
                return "wind"
            case "/wind_ovc":
            //Overcast and windy
                return "wind"
            case "/snow":
            //Snow
                return "snowflake"
            case "/rain_snow":
            //Rain/snow
                return "cloud.snow.fill"
            case "/rain_sleet":
            //Rain/sleet
                return "cloud.sleet.fill"
            case "/snow_sleet":
            //Snow/sleet
                return "cloud.sleet.fill"
            case "/fzra":
            //Freezing rain
                return "cloud.sleet.fill"
            case "/rain_fzra":
            //Rain/freezing rain
                return "cloud.sleet.fill"
            case "/snow_fzra":
            //Freezing rain/snow
                return "cloud.sleet.fill"
            case "/sleet":
            //Sleet
                return "cloud.sleet.fill"
            case "/rain":
            //Rain
                return "cloud.drizzle.fill"
            case "/rain_showers":
            //Rain showers (high cloud cover)
                return "cloud.rain.fill"
            case "/rain_showers_hi":
            //Rain showers (low cloud cover)
                return "cloud.heavyrain.fill"
            case "/tsra":
            //Thunderstorm (high cloud cover)
                return "cloud.bolt.rain.fill"
            case "/tsra_sct":
            //Thunderstorm (medium cloud cover)
                return "cloud.bolt.rain.fill"
            case "/tsra_hi":
            //Thunderstorm (low cloud cover)
                return "cloud.bolt.rain.fill"
            case "/tornado":
            //Tornado
                return "tornado"
            case "/hurricane":
            //Hurricane conditions
                return "hurricane"
            case "/tropical_storm":
            //Tropical storm conditions
                return "tropicalstorm"
            case "/dust":
            //Dust
                return "sun.dust.fill"
            case "/smoke":
            //Smoke
                return "smoke.fill"
            case "/haze":
            //Haze
                return "sun.haze.fill"
            case "/hot":
            //Hot
                return "thermometer.sun.fill"
            case "/cold":
            //Cold
                return "thermometer.snowflake"
            case "/blizzard":
            //Blizzard
                return "wind.snow"
            case "/fog":
            //Fog/mist
                return "cloud.fog.fill"
            default :
                return nil
        }
    }
}

struct RenderTemp: View {
    
    
    @State var temp: ForcastTime
    
    @State var hourText: String = ""
    
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .center, spacing: 0) {
                if temp.getSFIcon() == nil {
                    AsyncImage(
                        url: URL(string: temp.icon),
                        content: { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(maxWidth: g.size.width*0.5, maxHeight: g.size.height*0.3)
                        },
                        placeholder: {
                            ProgressView()
                        })
                        .padding(.top, g.size.height * 0.05)
                } else {
                    Image(systemName: temp.getSFIcon()!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                        .frame(maxWidth: g.size.width*0.5, maxHeight: g.size.height*0.3)
                        .padding(.top, g.size.height * 0.05)
                }
                
                Spacer()
                Text("\(temp.temperature)")
                    .foregroundColor(Color(.sRGB, white: 0.8833, opacity: 1))
                    .fontWeight(.thin)
                    .font(.system(size: 1000))
                    .minimumScaleFactor(0.001)
                    .frame(width: g.size.width*0.8, height: g.size.height*0.45)
                Text(hourText)
                    .fontWeight(.thin)
                    .font(.system(size: 1000))
                    .minimumScaleFactor(0.0001)
                    .frame(width: g.size.width*0.5, height: g.size.height*0.2)
            }
            .frame(width: g.size.width)
        }.onAppear() {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: temp.startTime!)
            hourText = renderHour(hour: hour)
        }
    }
    
    func renderHour(hour: Int) -> String {
        if hour == 0 {
            return "12am"
        } else if hour > 0 && hour < 12 {
            return "\(hour)am"
        } else if hour == 12 {
            return "12pm"
        } else {
            return "\(hour - 12)pm"
        }
    }
}
