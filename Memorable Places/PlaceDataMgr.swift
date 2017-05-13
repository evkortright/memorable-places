//
//  PlaceDataMgr.swift
//  Memorable Places
//
//  Created by Enrique V. Kortright on 5/12/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit
import CoreData

let delegate = UIApplication.shared.delegate as! AppDelegate
let context = delegate.persistentContainer.viewContext

func loadSampleData() {
    createPlace(name: "102 Allendale Dr.", latitude: 29.801299, longitude: -90.81199)
}

func createPlace(name: String, latitude : Double, longitude : Double) {
    let place = Place(context: context)
    place.name = name
    place.latitude = latitude
    place.longitude = longitude
    delegate.saveContext()
}

func getAllPlaces() -> [Place] {
    var places : [Place] = []
    do {
        try places = context.fetch(Place.fetchRequest()) as! [Place]
    } catch {
        print("getAllPlaces error.")
    }
    return places
}
