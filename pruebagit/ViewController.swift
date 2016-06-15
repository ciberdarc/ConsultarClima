//
//  ViewController.swift
//  pruebagit
////Tiempo
//  Created by Alexis Araujo on 6/13/16.
//  Copyright © 2016 Alexis Araujo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userCity: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func findWeather(sender: AnyObject) {
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
                var urlError = false
                var weather = ""
                let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                let urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                if urlContentArray.count > 1 {
                    let weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                    weather = weatherArray[0]
                    weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                    print(weather)
                }
                else {
                    urlError = true
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if urlError == true {
                        self.showError()
                    }
                    else {
                        self.resultLabel.text = weather
                    }
                })
            }
            task.resume()
        }
        else {
            showError()
        }

    }
    func showError(){
        resultLabel.text = "No se pudo encontrar el tiempo en " + userCity.text! + " Por favor, intentalo de nuevo"
    }
    
//Controlar el tiempo
    override func viewDidLoad() {
        super.viewDidLoad()
        userCity.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userCity.resignFirstResponder()
        return true
    }



}

