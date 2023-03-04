//
//  ViewController.swift
//  WeatherApp
//
//  Created by 강지원 on 2023/03/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherStackView: UIStackView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var cityNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameTextField.delegate = self
    }
    
    @IBAction func tapFatchWeatherButton(_ sender: Any) {
        if let cityName = self.cityNameTextField.text {//
            self.getCurrentWeather(cityName: cityName)/*사용자가 TextField의 쓴 도시이름을 넘겨줌*/
            self.view.endEditing(true)//버튼을 누르면 키보드창이 내려감
        }
    }
    
    func configureView(weatherInfomation: WeatherInformation) {
        self.cityNameLabel.text = weatherInfomation.name
        if let weather = weatherInfomation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInfomation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "최저: \(Int(weatherInfomation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "최고: \(Int(weatherInfomation.temp.maxTemp - 273.15))°C"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=e2c65d47e3e6181308ec415bb0410c0b") else { return }
        let session = URLSession(configuration: .default)//URLSession인스턴스 생성
        session.dataTask(with: url) { [weak self] data, response, error in //서버에 data요청
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }//바인딩이 되고 error가 nil이면 코드 실행
            /*guard 문 다음에는 현재 내에서 코드를 계속 실행하기 위해 true여야 하는 부울 표현식이 옵니다.이 경우 부울 식은 쉼표로 결합된 두 가지 조건으로 구성됩니다. */
            let decoder = JSONDecoder()//JSONDecoder인스턴스 생성
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                /*.self를 안해주면 WeatherInformation인스턴스를 매개변수로 쓴다는건데 만들어준 인스턴스도 없을뿐더러 여기서 쓰려는건
                 WeatherInformation의 타입이기때문에.self를 붙여준것이다*/
                DispatchQueue.main.async {/*네트워크 작업은 별도의 쓰레드에서 진행되고 응답이 온다해도
                                           자동으로 메인쓰레드로 돌아오지않기때문에 UI작업이 메인쓰레드에서 진행될수있게 하는 코드*/
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInfomation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                //statusCode가 successRange범위안이 아니면 서버에서 응답받은 에러 JSON데이터를 에러메세지 객체로 디코딩
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
}

extension ViewController: UITextFieldDelegate {//엔터로도 버튼눌렀을때 기능 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {//사용자가 텍스트필드를 편집할때 엔터키를 누르면 호출
        textField.resignFirstResponder()//일반적으로 텍스트필드에 텍스트입력을 마친 후 키보드 해제할때 사용
        self.tapFatchWeatherButton(self.weatherButton ?? 0)//버튼눌렀을때랑 같은기능호출
        return true
    }
}

