//
//  Meter.swift
//  AirMeter
//
//  Created by MacMini on 19.10.2021.
//

import Foundation
import CoreLocation



class MSLHome {
    
   static let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("msl").appendingPathExtension("plist")
    
   static var msls : [MSL] {
        
        get {
            if let data = try? Data(contentsOf: archiveURL) {
                return try! PropertyListDecoder().decode([MSL].self, from: data)
            } else {
                return []
            }
        }
        
        
        set {
            let data = try! PropertyListEncoder().encode(newValue)
            try! data.write(to: archiveURL)
        }
    }
}


struct AirDays: Codable {
    let data : [AirDay]
}

struct AirDay : Codable, Hashable {
    let datetime : String
    let indexes : MainInfo
    
    
    var dateString : String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = formatter.date(from: datetime) {
                
                formatter.dateFormat = "EEEE, dd MMMM HH:mm"
                return formatter.string(from: date)
            }
            
            return "no date"
        }
    }
    
}

struct MSL : Codable, Hashable, Equatable {
    let l : String
    let lt,lg : Double
    
    
}


struct Pollutants : Codable {
  
    
    let  co    : Pollutant?
    let  c6h6 : Pollutant?
    let  ox : Pollutant?
    let  o3 : Pollutant?        
    let  nh3 : Pollutant?
    let  nmhc : Pollutant?
    let  no : Pollutant?
    let  nox : Pollutant?
    let  no2 : Pollutant?
    let  pm25 : Pollutant?
    let  pm10 : Pollutant?
    let  so2 : Pollutant?
    let  trs : Pollutant?
   
}


struct Pollutant : Codable, Hashable, Equatable {
   
    let id = UUID()
    let full_name : String
    let  aqi_information : PollutantInformation
    
    static func == (lhs: Pollutant, rhs: Pollutant) -> Bool {
        lhs.id == rhs.id
    }
    
}


struct PollutantInformation : Codable , Hashable {
    let id = UUID()
    let baqi : ChildInfo
}

struct AirMeter : Codable {
    
    let data : AqiMeter
}


struct AqiMeter : Codable {
    let  health_recommendations : [String : String]
    let indexes : MainInfo
    let pollutants : Pollutants
}

struct MainInfo : Codable, Hashable {
    let baqi : ChildInfo
}

struct ChildInfo : Codable, Hashable {
    let id = UUID()
    let aqi : Int
    let category : String
    let color : String
    let dominant_pollutant : String?
    
}





class Meter {
    
    
    
    static  func execute(for  location : CLLocation, completion : @escaping (Result<AirMeter,Error>) -> Void )  {
        let urlString = "https://api.breezometer.com/air-quality/v2/current-conditions?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&key=10c375f60b364d41a125721739824c11&features=breezometer_aqi,local_aqi,health_recommendations,sources_and_effects,pollutants_concentrations,pollutants_aqi_information&metadata=true"
        
        guard let url = URL(string: urlString) else { return }
    
        
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                
                completion(.failure(error))
                return
            }
            guard let data = data else {
                return
            }

            
            print(try? JSONSerialization.jsonObject(with: data, options: []))
            do {
                let succesfulModel = try JSONDecoder().decode(AirMeter.self, from: data)
                completion(.success(succesfulModel))
            } catch {
                completion(.failure(error))
            }
            
            
        }.resume()
        
    }
    
    
    static func forecastConnection(for location : CLLocation, completion :@escaping (Result<AirDays,Error>) -> Void) {
        
        let urlString = "https://api.breezometer.com/air-quality/v2/forecast/hourly?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&key=10c375f60b364d41a125721739824c11&hours=24&features=breezometer_aqi"
        guard let url = URL(string: urlString) else { return }
    
        
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                
                completion(.failure(error))
                return
            }
            guard let data = data else {
                return
            }

            
            print(try? JSONSerialization.jsonObject(with: data, options: []))
            do {
                let succesfulModel = try JSONDecoder().decode(AirDays.self, from: data)
                completion(.success(succesfulModel))
            } catch {
                completion(.failure(error))
            }
            
            
        }.resume()
        
        
        
        
    }
    
    
}
