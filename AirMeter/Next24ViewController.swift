//
//  Next24ViewController.swift
//  AirMeter
//
//  Created by MacMini on 19.10.2021.
//

import UIKit
import CoreLocation

@available(iOS 15.0, *)
class Next24ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var locationFetched : CLLocation?
    
    var dataSource : UITableViewDiffableDataSource<Int,AirDay>!
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.frame = view.bounds
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = view.backgroundColor
        activityIndicator.color = .darkGray
     
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setDatasource()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "air")
        
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.locationFetched == currentLocation {
            return
        }
        
        if let currentLocation = currentLocation {
            activityIndicator.startAnimating()
            Meter.forecastConnection(for: currentLocation) { result in
                
                switch result {
                case .success(let days) :
                    DispatchQueue.main.async {
                        var snap = NSDiffableDataSourceSnapshot<Int,AirDay>()
                        snap.appendSections([0])
                        self.locationFetched = currentLocation
                        snap.appendItems(days.data, toSection: 0)
                        
                        self.dataSource.apply(snap, animatingDifferences: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                    }
                case .failure(let error) :
                    print(error)
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        
      
        
    }
    
    
    func hexToUIColor(str : String) -> UIColor? {
        let chars = Array(str.dropFirst())
        
        return UIColor(red: .init(strtoul(String(chars[0...1]), nil, 16))/255, green: .init(strtoul(String(chars[2...3]), nil, 16))/255, blue: .init(strtoul(String(chars[4...5]), nil, 16))/255, alpha: 1)
        
    }
    
    
    func setDatasource() {
        
        dataSource = UITableViewDiffableDataSource<Int,AirDay>(tableView: tableView, cellProvider: { tableView, indexPath, airDay in
            let cell = tableView.dequeueReusableCell(withIdentifier: "air")!
            
            
            
            var cellConfig = cell.defaultContentConfiguration()
            
            cellConfig.text = "\(airDay.indexes.baqi.aqi)"
            cellConfig.secondaryText = "\(airDay.indexes.baqi.category)\n\(airDay.dateString)"
            cellConfig.secondaryTextProperties.numberOfLines = 2
            cellConfig.image = UIImage(systemName: "aqi.medium")
            
            cellConfig.imageProperties.tintColor = self.hexToUIColor(str: airDay.indexes.baqi.color)
           
            
            cell.contentConfiguration = cellConfig
            
            
            return cell
        })
        
        
    }
    
    
    
   

}
