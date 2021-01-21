//
//  GridCreator.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/2/21.
//

import Foundation
import SpriteKit

class GridCreator {
    var grid: [ [Tile] ] = [ [Tile] ]()
    var childrenToAddToView: [Floor : CGPoint] = [Floor : CGPoint]()
    
    func getGridOfScenesChildren(_ children: [SKNode]) -> [ [Tile] ] {
        var arrayOfNodes: [Tile] = []
        
        for child in children {
            // A player and crate will always be standing on a floor, so you can add them normally to the arrayOfNodes and just remember they're on Floor tiles;
            // replace them later
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            
            if child as? MSButtonNode == nil && child as? LaserPointer == nil {
                arrayOfNodes.append(child as! Tile)
            }
        }
        
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midX < $1.frame.midX })
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midY > $1.frame.midY })
                
        grid = arrayOfNodes.chunked(into: 8)

        for r in grid {
            var row = r
            row = row.sorted(by: { $0.frame.midX < $1.frame.midX })
        }
        
        // Replace player + crate nodes w/ Floor nodes that have crate and player properties
        putFloorsUnderPlayerAndCrates()

        return grid
    }
    
    func getLaserPointerNodesFromScenesChildren(_ children: [SKNode]) -> [LaserPointer] {
        var laserPointers: [LaserPointer] = []

        for child in children {
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            
            if child as? LaserPointer != nil {
                (child as? LaserPointer)?.setDirection()
                laserPointers.append(child as! LaserPointer)
            }
        }
        
        return laserPointers
    }
    
    // The way this is built, the player will never start the level on a storage area
    func putFloorsUnderPlayerAndCrates() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                
                if grid[row][col].name == Constants.TileNames.player.rawValue {
                    let playerNode: Player = grid[row][col] as! Player
                    
                    // Replace w/ Floor tile w/ non-nil player property
                    grid[row][col] = Floor()
                    (grid[row][col] as! Floor).player = playerNode
                    
                    let position: CGPoint = CGPoint(x: col * Constants.tileSize + 139, y: 900 - (row * Constants.tileSize))
                    (grid[row][col] as! Floor).position = position

                    childrenToAddToView[grid[row][col] as! Floor] = CGPoint(x: col * Constants.tileSize + 139, y: 900 - (row * Constants.tileSize))
                } else if grid[row][col].name == Constants.TileNames.crate.rawValue {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Floor tile w/ non-nil crate property
                    grid[row][col] = Floor()
                    (grid[row][col] as! Floor).crate = crate

                    let position: CGPoint = CGPoint(x: col * Constants.tileSize + 139, y: 900 - (row * Constants.tileSize))
                    (grid[row][col] as! Floor).position = position
                    
                    childrenToAddToView[grid[row][col] as! Floor] = position
                }
                
            }
        }
        
    }

}
