//
//  ViewController.swift
//  Memorable Places
//
//  Created by Enrique V. Kortright on 5/12/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var places : [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
//        loadSampleData()
        places = getAllPlaces()
        print("places: \(places)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        places = getAllPlaces()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapSegue", sender: places[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?    ) {
        let nextVC = segue.destination as! MapViewController
        if sender != nil {
            if let place = sender as? Place {
                print("place: \(place)")
                nextVC.place = place
            }
        }
    }
}

