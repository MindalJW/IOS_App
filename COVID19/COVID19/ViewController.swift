//
//  ViewController.swift
//  COVID19
//
//  Created by 강지원 on 2023/03/04.
//

import Alamofire
import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var totalCaseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverview(completionHandler: { [weak self] result in //후행클로저, 비동기처리가 완료되면 result개체와 함께 클로저가 호출
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverView: result)
                self.configureChatView(covidOverViewList: covidOverviewList)
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    func makeCovidOverviewList(
        cityCovidOverView: CityCovidOverView
    ) -> [CovidOverview] {
        return [cityCovidOverView.seoul,
                cityCovidOverView.busan,
                cityCovidOverView.daegu,
                cityCovidOverView.incheon,
                cityCovidOverView.gwangju,
                cityCovidOverView.daejeon,
                cityCovidOverView.ulsan,
                cityCovidOverView.sejong,
                cityCovidOverView.gyeonggi,
                cityCovidOverView.chungbuk,
                cityCovidOverView.chungnam,
                cityCovidOverView.gyeongnam,
                cityCovidOverView.gyeongbuk,
                cityCovidOverView.jeju
                ]
}
    
    func configureChatView(covidOverViewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        let entries = covidOverViewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil } /*PieChartDataEntry?(nil or PieChartDataEntry)를 반환해야하는데
                                                       항상하던대로 그냥 { return }을 해버리면 void를 반환하는거로되서 오류가남*/
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8//선이 시작하는 곳 위치
        dataSet.valueLinePart1Length = 0.2//그래프에서 나가는 선길이
        dataSet.valueLinePart2Length = 0.3//나가다가 꺾이는선 길이
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.liberty() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.pastel() +
        ChartColorTemplates.material()
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0/*이는 문자열 인수가 포맷터에서 구문 분석할 수 있는 유효한 숫자가
                                                                아닐 수 있기 때문입니다.*/
    }
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
    }
    
    /*일단 completionHandler는 비동기 처리를 할때 사용되는데 비동기처리는 작업이 끝날때 까지 기다리지않는다는뜻임
    작업이 끝날때까지 기다리면 시스템이 느려지게될때 사용함. 예로는 네트워크 요청이 있음.
    일단 이 함수 자체가 비동기 처리인데 일단 api get요청을 만듬. 응답 데이트또한 responseData에서 비동기적으로 처리됨
    응답이 성공하면 completionHandler를 호출해 성공을 알림, 실패하면 실패했다고함.
     그 다음 응답이 성공여부에 따라 성공하면 데이터를 받아오고 그 데이터를 디코딩함. 데이터 디코딩이 성공하면
     fetchCovidOverview함수의 completionHandler를 호출해서 성공여부와 데이터를 Result객체로 반환함
     클로저는 함수이다. (Result<CityCovidOverView, Error>)라는 객체를 매개변수로 받아서 아무것도 반환하지 않는 '함수'
     디코드가 성공했을때 매개변수로 성공여부와연관값((Result<CityCovidOverView, Error>))을 매개변수로 클로저에게 던져줌.
     그럼 클로저는 그매개변수를 이용한 함수를 후행클로저를 이용해서 함수 정의부에서 구현하면된다.
     함수가 종료되어도 클로저가 여전히 유효하게 @escaping을 사용.
     */
    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void)
    {//함수가 반환된 후 미래 특정시점에 클로저가 실행될수있게 @escaping을 사용
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "xqiQILDh9ZSTVCocOd7N6uJRvPBsE5mbl"
        ]
        AF.request(url,method: .get, parameters: param)
            .responseData(completionHandler: { response in//비동기처리가 완료되면 reponse객체와 함께 클로저completionHandler 호출
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))//성공 전달
                    } catch {
                        completionHandler(.failure(error))//실패 전달
                    }
                case let .failure(error):
                    completionHandler(.failure(error))//실패 전달
                }
            })
    }
}


extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
  
