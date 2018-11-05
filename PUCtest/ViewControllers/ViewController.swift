//
//  ViewController.swift
//  PUCtest
//
//  Created by MAGNANIG-NB on 03/11/2018.
//  Copyright © 2018 MAGNANIG-NB. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol DropDownProtocol {
    func dropDown(pressed: Any)
}

class ViewController: UIViewController, DropDownProtocol, UISearchBarDelegate {

    private var sportMenu = DropDownView()
    private var googleMenu: DropDownView?
    
    private var sportMenuHeight = NSLayoutConstraint()
    private var googleMenuHeight = NSLayoutConstraint()
    
    private var isOpen = false
    private var sports = [Sport]()
    private var sportSelected: Sport? = nil
    private var placeSelected: GMSAutocompletePrediction? = nil
    private var place: GMSPlace? = nil
    private var sv = UIView()
    private var resultsArray = [GMSAutocompletePrediction]()
    private var datePicker: UIDatePicker?
    private var tapGesture: UIGestureRecognizer?
    private let dateFormatter = DateFormatter()

    @IBOutlet weak var dateAndTimeTextfield: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sportMenuButton: UIButton!
    @IBOutlet weak var trovaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.sportMenuButton.isUserInteractionEnabled = true
        self.sv = UIViewController.displaySpinner(onView: self.view)
        self.startReq()
        self.configurePickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.sportMenu.dropDownOptions.isEmpty {
            self.sportMenuButton.isUserInteractionEnabled = false
            return
        }
        self.sportMenuButton.isUserInteractionEnabled = true
    }

    //MARK: Sport menu
    func configureSportsMenu() {
        sportMenu = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        sportMenu.delegate = self
        sportMenu.isGoogleMenu = false
        sportMenu.translatesAutoresizingMaskIntoConstraints = false
        self.sportMenu.dropDownOptions = sports
        self.sportMenuButton.isUserInteractionEnabled = true
        self.sportMenuButton.superview?.addSubview(sportMenu)
        self.sportMenuButton.superview?.bringSubview(toFront: sportMenu)
        sportMenu.topAnchor.constraint(equalTo: self.sportMenuButton.bottomAnchor).isActive = true
        sportMenu.centerXAnchor.constraint(equalTo: self.sportMenuButton.centerXAnchor).isActive = true
        sportMenu.widthAnchor.constraint(equalTo: self.sportMenuButton.widthAnchor).isActive = true
        self.sportMenuHeight = sportMenu.heightAnchor.constraint(equalToConstant: 0)
    }
    
    
    @IBAction func openMenu(_ sender: Any) {
        if isOpen {
            self.dismissDropDown(menu: sportMenu, height: sportMenuHeight)
        } else {
            isOpen = true
            self.openDropDown(menu: sportMenu, height: sportMenuHeight)
        }
    }
    
    //MARK: Google Menu
    func configureGoogleMenu() {
        self.googleMenu = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        googleMenu!.delegate = self
        googleMenu!.isGoogleMenu = true
        googleMenu!.translatesAutoresizingMaskIntoConstraints = false
        self.googleMenu!.dropDownGoogleOptions = self.resultsArray
        self.searchBar.superview?.addSubview(googleMenu!)
        self.searchBar.superview?.bringSubview(toFront: googleMenu!)
        googleMenu!.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        googleMenu!.centerXAnchor.constraint(equalTo: self.searchBar.centerXAnchor).isActive = true
        googleMenu!.widthAnchor.constraint(equalTo: self.searchBar.widthAnchor).isActive = true
        self.googleMenuHeight = googleMenu!.heightAnchor.constraint(equalToConstant: 0)
        self.openDropDown(menu: googleMenu!, height: googleMenuHeight)
    }
    
    
    //MARK: Menu
    func openDropDown(menu: DropDownView, height: NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([height])
        if menu.tableView.contentSize.height > 250 {
            height.constant = 150
        } else {
            height.constant = menu.tableView.contentSize.height
        }
        NSLayoutConstraint.activate([height])
        UIView.animate(withDuration: 0.0, delay: 0, usingSpringWithDamping: 0.00, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
            menu.layoutIfNeeded()
            menu.center.y += menu.frame.height / 2
        }, completion: nil)
    }

    func dismissDropDown(menu: DropDownView, height: NSLayoutConstraint) {
        isOpen = false
        NSLayoutConstraint.deactivate([height])
        height.constant = 0
        NSLayoutConstraint.activate([height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            menu.center.y -= menu.frame.height / 2
            menu.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: Menu protocol
    func dropDown(pressed: Any) {
        if let sport = pressed as? Sport {
            print(sport.name)
            self.sportSelected = sport
            self.dismissDropDown(menu: sportMenu, height: sportMenuHeight)
            self.sportMenuButton.setTitle(sport.name, for: .normal)
            
        } else if let place = pressed as? GMSAutocompletePrediction {
            self.searchBar.text = place.attributedFullText.string
            self.placeSelected = place
            self.getLonLat()
            guard let menu = googleMenu else {
                return
            }
            self.dismissDropDown(menu: menu, height: googleMenuHeight)
        }
    }
 
    //MARK: searchBar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 4 {
            if googleMenu != nil {
                self.dismissDropDown(menu: googleMenu!, height: googleMenuHeight)
                self.placeSelected = nil
                self.place = nil
            }
            return
        }
        let placesClient = GMSPlacesClient()
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, error) in
            self.resultsArray.removeAll()
            guard let places = results else {
                return
            }
            for place in places {
                self.resultsArray.append(place)
            }
            if self.googleMenu != nil {
                self.dismissDropDown(menu: self.googleMenu!, height: self.googleMenuHeight)
            }
            self.configureGoogleMenu()
        }
    }
    
    //MARK: date picker
    @objc func dateChanged(datePicker: UIDatePicker)  {
        dateAndTimeTextfield.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func annullaPicker() {
        dateAndTimeTextfield.text = ""
        view.endEditing(true)
        guard let tap = self.tapGesture else {
            return
        }
        view.removeGestureRecognizer(tap)
    }
    
    @objc func viewTap(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        guard let tap = self.tapGesture else {
            return
        }
        view.removeGestureRecognizer(tap)
    }
    
    @IBAction func tappedPickerTextView(_ sender: Any) {
        guard let tap = self.tapGesture else {
            return
        }
        dateAndTimeTextfield.text = dateFormatter.string(from: Date())
        view.addGestureRecognizer(tap)
    }
    func configurePickerView() {
        self.dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTap(gestureRecognizer:)))
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        dateAndTimeTextfield.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(ViewController.viewTap(gestureRecognizer:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Annulla", style: .plain, target: self, action: #selector(ViewController.annullaPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateAndTimeTextfield.inputAccessoryView = toolBar
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
      
    }
    
    //MARK: Rest Services
    func startReq()  {
        let serviceRequester = ServiceRequester()
        let completionHandler = {
            guard let sports = serviceRequester.sports else { return }
            DispatchQueue.main.async(execute: {
                self.sports = sports
                self.configureSportsMenu()
                UIViewController.removeSpinner(spinner: self.sv)
            })
            
        }
        let errCompletionHandler = {
            (error: String) -> Void in
            print("\(error) ERROR getting data from API")
            UIViewController.removeSpinner(spinner: self.sv)
            self.showAlert()
            self.sportMenuButton.isUserInteractionEnabled = false
        }
        print(#function)
        serviceRequester.makeRequest(completionHandler: completionHandler, errCompletionHandler: errCompletionHandler)
    }
    
    func getLonLat() {
        let placesClient = GMSPlacesClient()
        guard let placeID = self.placeSelected?.placeID else {
            return
        }
        placesClient.lookUpPlaceID(placeID, callback: { (placeResult, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = placeResult else {
                print("No place details for \(placeID)")
                return
            }
            self.place = place
        })
    }
    //MARK: ALERT
    func showAlert() {
        let alertController = UIAlertController(title: "Errore", message: "Riprovare più tardi", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Gestione del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "result_ID" {
            let resultVC = segue.destination as! ResultViewController
            if let sport = sportSelected {
                resultVC.sport = sport
            } 
            resultVC.place = self.place
            if let indirizzo = self.placeSelected?.attributedFullText.string {
                resultVC.indirizzo = indirizzo
            }
            resultVC.dateAndTime = self.dateAndTimeTextfield.text
        }
    }
}

//MARK: Spinner
extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

