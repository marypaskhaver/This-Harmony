//
//  Constants.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/2/21.
//

import Foundation

class Constants {
    static let tileSize: Int = 70
    static let movementAnimationDuration: TimeInterval = 0.2
    
    enum TileNames: String {
        case floor = "floor"
        case crate = "crate"
        case wall = "wall"
        case player = "player"
        case storage = "storage"
        case laserPointer = "laser_pointer"
        case laserBeam = "laser_beam"
    }
}
