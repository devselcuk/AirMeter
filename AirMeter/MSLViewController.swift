//
//  MSLViewController.swift
//  AirMeter
//
//  Created by MacMini on 19.10.2021.
//

import UIKit
import CoreLocation

@available(iOS 15.0, *)
class MSLViewController: UIViewController {
    
    var locations : [MSL] = []
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource : UITableViewDiffableDataSource<Int,MSL>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "msl")
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.locations = MSLHome.msls
        self.updateList()
        
    }
    
    func setDataSource() {
        dataSource = UITableViewDiffableDataSource<Int,MSL>(tableView: tableView, cellProvider: { tableView, indexPath, savedLocation in
            let cell = tableView.dequeueReusableCell(withIdentifier: "msl")
            cell?.backgroundColor = .clear
            var congif = cell?.defaultContentConfiguration()
            
            congif?.text = savedLocation.l
            
            congif?.secondaryText = "\(savedLocation.lt)\n\(savedLocation.lg)"
            congif?.secondaryTextProperties.numberOfLines = 2
            
            
            cell?.contentConfiguration = congif
            
            return cell
        })
    }
    
    
    func updateList() {
        
        
        var snap = NSDiffableDataSourceSnapshot<Int,MSL>()
        
        snap.appendSections([0])
        snap.appendItems(self.locations, toSection: 0)
        
        dataSource.apply(snap, animatingDifferences: true, completion: nil)
        
        
    }
    

}

@available(iOS 15.0, *)
extension MSLViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.locations[indexPath.row]
        globalLocation = CLLocation(latitude: location.lt, longitude: location.lg)
        tabBarController?.selectedIndex = 0
    }
    
    
}
