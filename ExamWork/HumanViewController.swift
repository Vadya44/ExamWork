//
//  HumanViewController.swift
//  ExamWork
//
//  Created by Вадим Гатауллин on 25/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit
import MapKit

public protocol savingSurName {
    func saveNewSurName(newSur: String, index: Int) 
}

class HumanViewController: UIViewController {

    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var humTextField: UITextField!
    var isSaved = false
    var locValue: CLLocationCoordinate2D?
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var index: Int?
    
    var delegate : savingSurName?
    var human: Human?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.humLabel.text = human?.surname
        self.humTextField.text = human?.surname
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    func initHuman(hum: Human, index: Int) {
        self.human = hum
        self.index = index
    }
    
    func initDelegate(del: savingSurName) {
        self.delegate = del
    }

    @IBAction func undoButtonClicked(_ sender: Any) {
        if (self.humTextField.text != self.humLabel.text) {
            let alert = UIAlertController(title: "Alert",
                                          message: "Ты изменил, но не сохранил",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Сейчас сохраню", style: .default, handler: { action in
                switch action.style{
                case .default:
                    break
                case .cancel:
                    break
                    
                case .destructive:
                    break
                }}))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        if (self.humTextField.text != self.humLabel.text) {
            self.delegate?.saveNewSurName(newSur: self.humTextField.text ?? "Ты ввел пустоту", index: self.index!)
            self.isSaved = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HumanViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locValue = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue!, span: span)
        mapView.setRegion(region, animated: true)
        let _ = getAddressFromLatLon(lat: locValue!.latitude, lon: locValue!.longitude)
        
        //centerMap(locValue)
    }
    
    func getAddressFromLatLon(lat: Double,  lon: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                let allAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(allAnnotations)
                
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.locValue!
                    annotation.title = "lat:\(self.locValue!.latitude)long:\(self.locValue!.longitude)"
                    annotation.subtitle = addressString
                    self.mapView.addAnnotation(annotation)
                }
        })
    }
}
