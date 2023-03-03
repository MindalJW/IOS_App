//
//  ViewController.swift
//  WeatherApp
//
//  Created by 강지원 on 2023/03/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapFatchWeatherButton(_ sender: Any) {
        if let cityName = self.cityNameTextField.text {//
            self.getCurrentWeather(cityName: cityName)/*사용자가 TextField의 쓴 도시이름을 넘겨줌*/
            self.view.endEditing(true)//버튼을 누르면 키보드창이 내려감
        }
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=e2c65d47e3e6181308ec415bb0410c0b") else { return }
        let session = URLSession(configuration: .default)//URLSession인스턴스 생성
        session.dataTask(with: url) { data, response, error in //서버에 data요청
            guard let data = data, error == nil else { return }//바인딩이 되고 error가 nil이면 코드 실행
            /*guard 문 다음에는 현재 내에서 코드를 계속 실행하기 위해 true여야 하는 부울 표현식이 옵니다.이 경우 부울 식은 쉼표로 결합된 두 가지 조건으로 구성됩니다. */
            let decoder = JSONDecoder()//JSONDecoder인스턴스 생성
            guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
            /*.self를 안해주면 WeatherInformation인스턴스를 매개변수로 쓴다는건데 만들어준 인스턴스도 없을뿐더러 여기서 쓰려는건
             WeatherInformation의 타입이기때문에.self를 붙여준것이다*/
            debugPrint(weatherInformation)
        }.resume()
    }
}

