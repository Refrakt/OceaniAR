//
//  WeatherMap.swift
//  OceaniAR
//
//  Created by Michael Schröder on 18.09.18.
//  Copyright © 2018 Refrakt. All rights reserved.
//
//  based on https://github.com/mapbox/webgl-wind
//

import Foundation

class WeatherMap {
        
    let particleScreen: ParticleScreen
    let plane: SimplePlane
    
    struct Config: Codable {
        let mapWidth: Int
        let mapHeight: Int
        let fadeOpacity: Float
        let colorFactor: Float
        let speedFactor: Float
        let dropRate: Float
        let dropRateBump: Float
        let resolution: Int
        let colors: [HexColor]
    }
    
    init(config: Config, oceanCurrents: OceanCurrents) {
        let particleState = ParticleState(resolution: config.resolution, oceanCurrents: oceanCurrents)
        particleState.speedFactor = config.speedFactor
        particleState.dropRate = config.dropRate
        particleState.dropRateBump = config.dropRateBump
        let colors = config.colors.map{$0.uiColor.cgColor}
        let colorRamp = ColorRamp(colors: colors)
        particleScreen = ParticleScreen(width: config.mapWidth, height: config.mapHeight, particleState: particleState, colorRamp: colorRamp)
        particleScreen.colorFactor = config.colorFactor
        particleScreen.fadeOpacity = config.fadeOpacity
        self.plane = SimplePlane(width: config.mapWidth, height: config.mapHeight)
    }
    
    func render(on target: ARViewController.Target) {
        particleScreen.particleState.update()
        particleScreen.draw()
        plane.render(texture: particleScreen.texture, on: target)
    }
    
}