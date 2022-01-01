//
//  HomeViewController.swift
//  TaxiDriver
//
//  Created by Ye Lynn Htet on 29/12/2021.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseFirestore
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var customerTableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    var cusArray = [CustomerModel]()
    var filteredCus = [CustomerModel]()
    
    var isSearch = false
    var searchText = ""
    
    
    var currentLat: Double = 0.0
    var currentLog: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerTableView.dataSource = self
        customerTableView.delegate = self
        customerTableView.register(UINib(nibName: "CustomerTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerTableViewCell")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchBar.delegate = self
        
        decorateUI()
        
    }
    
    func decorateUI() {
        profileImage.layer.cornerRadius = 12
        headerContainerView.layer.cornerRadius = 16
        headerContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner , .layerMinXMaxYCorner]
        
        usernameLabel.text = userDefaults.string(forKey: "username")
        setImage(with: userDefaults.string(forKey: "profileURL")!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func goToProfile() {
        performSegue(withIdentifier: "GoToProfile", sender: self)
    }
    
    func setImage(with urlString: String) {
        print(urlString)
        let url = URL(string: urlString)!
        let placeholderImage = UIImage(named: "profile_sample")
        profileImage.af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2))
    }
  
}

//MARK: - TableView Datasource and Delegate Methods

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredCus.count
        } else {
            return cusArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTableViewCell", for: indexPath) as! CustomerTableViewCell
        if isSearch {
            cell.configure(with: filteredCus[indexPath.row])
        } else {
            cell.configure(with: cusArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "GoToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToMap"{
            let destinationVC = segue.destination as! MapViewController
            if let indexPath = customerTableView.indexPathForSelectedRow {
                if isSearch {
                    destinationVC.selectedCustomer = filteredCus[indexPath.row]
                }else {
                    destinationVC.selectedCustomer = cusArray[indexPath.row]
                }
                destinationVC.currentLat = currentLat
                destinationVC.currentLog = currentLog
            }
        }
        
    }
    
}

//MARK: - CLLocationManager Delegate Methods

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            currentLat = Double(location.coordinate.latitude)
            currentLog = Double(location.coordinate.longitude)
            print("Lat = \(String(describing: currentLat)), Log = \(String(describing: currentLog))")
            self.loadCustomers(currentLat: currentLat, currentLog: currentLog)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func loadCustomers(currentLat: Double, currentLog: Double) {
        db.collection("customer").addSnapshotListener { querySnapshot, error in
            self.cusArray.removeAll()
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        
                        let data = doc.data()
                        
                        if let name = data["name"] as? String, let phone = data["phone"] as? String, let photo = data["img_url"] as? String, let lat = data["lat"] as? Double, let log = data["log"] as? Double {
                            
                            let distance = self.calculateDistance(fromLat: currentLat, fromLog: currentLog, desLat: lat, desLog: log)
                            
                            let customer = CustomerModel(cusName: name, cusPhone: phone, cusLat: lat, cusLog: log, cusPhoto: photo, cusDistance: distance)
                            
                            self.cusArray.append(customer)
                            
                        }
                    }
                    self.cusArray.sort { $0.cusDistance < $1.cusDistance }
                    
                    DispatchQueue.main.async {
                        
                        self.customerTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func calculateDistance(fromLat: Double, fromLog: Double, desLat: Double, desLog: Double) -> Double {
        
        let currentCoordinate = CLLocation(latitude: fromLat, longitude: fromLog)
        let destinationCoordinate = CLLocation(latitude: desLat, longitude: desLog)
        
        let distance = currentCoordinate.distance(from: destinationCoordinate)/1000
        
        return Double(String(format: "%.2f", distance))!
        
    }
    
}
//MARK: - SearchBar Delegate Methods

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchBar.text!
        
        if searchText != "" {
            isSearch = true
            filterText(searchText)
            
        } else {
            isSearch = false
            locationManager.requestLocation()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchText = searchBar.text!
        
        if searchText != "" {
            isSearch = true
            filterText(searchText)
            
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        searchBar.endEditing(true)
        
    }
    
    func filterText(_ query: String) {
        
        filteredCus.removeAll()
        
        for customer in cusArray {
            
            if customer.cusName.lowercased().contains(query.lowercased()) {
                
                filteredCus.append(customer)
                
            }
        }
        
        customerTableView.reloadData()
    }
}
