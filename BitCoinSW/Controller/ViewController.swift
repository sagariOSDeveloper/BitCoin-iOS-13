//
//  ViewController.swift
//  BitCoinSW
//
//  Created by Sagar Baloch on 15/01/2020.
//  Copyright © 2020 Sagar Baloch. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate {

    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    var activiyIndicator=UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
        currencyPicker.dataSource=self
        currencyPicker.delegate=self
        coinManager.delegate=self
    }
}

//MARK: - UIPickerView Data Source Extension
extension ViewController:UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        startActivityIndicator()
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK: - Updating UI using CurrencyDelegate
extension ViewController:CurrenyDelegate{
    func didFailWithError(error: Error) {
        print("Fail with error: \(error)")
        stopActivityIndicator()
    }
    
    func didUpdateUI(_ coinManager: CoinManager, price: CoinModel) {
        DispatchQueue.main.async {
            print("In Method Update UI ")
            self.bitCoinLabel.text="\(price.price)"
            self.currencyLabel.text="\(price.currency)"
            self.stopActivityIndicator()
        }
    }
}
//MARK: - ActivityIndicator
extension ViewController{
    func createActivityIndicator(){
        activiyIndicator.center=self.view.center
        activiyIndicator.hidesWhenStopped=true
        activiyIndicator.style=UIActivityIndicatorView.Style.large
        view.addSubview(activiyIndicator)
    }
    
    func startActivityIndicator(){
        activiyIndicator.startAnimating()
        self.view.isUserInteractionEnabled=false
    }
    
    func stopActivityIndicator(){
        activiyIndicator.stopAnimating()
        self.view.isUserInteractionEnabled=true
    }
}
