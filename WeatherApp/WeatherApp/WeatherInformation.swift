//
//  WeatherInformation.swift
//  WeatherApp
//
//  Created by 강지원 on 2023/03/03.
//

import Foundation

struct WeatherInformation: Codable {
    let weather: [Weather]//날씨배열
    let temp: Temp//온도
    let name: String//도시이름
    
    enum CodingKeys: String, CodingKey {//JSON파일의 데이터이름 매핑시켜주기위함
        case weather
        case temp = "main"//받아올 JOSN파일의 데이터이름이 "main"이고 Swift에서 temp로 사용
        case name
    }
}

struct Weather: Codable {//받아올 JOSN파일의 데이터이름과 똑같이 만들어줌
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {//다르게 설정하고 싶은 경우, CodingKey프로토콜을 사용
    let temp: Double
    let feelsLike: Double
    let minTemp:Double
    let maxTemp:Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
