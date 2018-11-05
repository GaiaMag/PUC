//
//  ResultViewController.swift
//  PUCtest
//
//  Created by MAGNANIG-NB on 04/11/2018.
//  Copyright © 2018 MAGNANIG-NB. All rights reserved.
//

import UIKit
import GooglePlaces

class ResultViewController: UIViewController {
    var sport: Sport? = nil
    var place: GMSPlace? = nil
    var indirizzo: String? = nil
    var dateAndTime: String? = nil

    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var indirizzoLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        self.sportLabel.text = sport?.name
        self.dateAndTimeLabel.text = self.dateAndTime
        self.indirizzoLabel.text = self.indirizzo
        guard let coordinate = place?.coordinate else {
            return
        }
        self.latLabel.text = coordinate.latitude.description
        self.longLabel.text = coordinate.longitude.description
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sportLabel.text = "-"
        self.dateAndTimeLabel.text = "-"
        self.indirizzoLabel.text = "-"
        self.latLabel.text = "-"
        self.longLabel.text = "-"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
