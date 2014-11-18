//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by NanYar on 17.11.14.
//  Copyright (c) 2014 NanYar. All rights reserved.
//

import UIKit
//import Foundation

class ViewController: UIViewController
{
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func weatherButtonPressed(sender: UIButton)
    {
        self.view.endEditing(true) // Retract the keyboard
        
        var cityString = cityTextField.text.capitalizedString
        cityString = cityString.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        let urlString = "http://www.weather-forecast.com/locations/" + cityString + "/forecasts/latest"
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)
        {
            (data, response, error) in
            
            if let urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)
            {
                if urlContent.containsString("<span class=\"phrase\">")
                {
                    let contentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    let contentOfSecondHalfArray = contentArray[1].componentsSeparatedByString("</span>")
                    
                    let weatherForecast = contentOfSecondHalfArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.weatherMessageLabel.hidden = false
                        self.weatherMessageLabel.text = cityString + "\n1 – 3 Day Weather Forecast:\n\n" + weatherForecast
                        self.cityTextField.text = ""
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.weatherMessageLabel.hidden = false
                        self.weatherMessageLabel.text = "😱\nCould not find \"" + self.cityTextField.text + "\"\nPlease try again!"
                        self.cityTextField.text = ""
                    }
                }
            }
        }
        task.resume()
    }

}
