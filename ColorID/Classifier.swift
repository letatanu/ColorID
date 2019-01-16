//
//  Classifier.swift
//  ColorID
//
//  Created by Le Nhut on 8/1/18.
//  Copyright © 2018 Le Nhut. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Accelerate
import Darwin

typealias Vectors = Array<[UIColor]>
typealias Vector = [UIColor]

class Classifier: NSObject {
    static let sharedInstance = Classifier()
    private var k = 0
    private var values: Vector = Vector()
    private var finalClusters: Vectors = Vectors()
    private var centroids: Vector = Vector()
    private var maxInterator: Int = 800
    private var oldClusters: Vectors = Vectors()
    private var currentClusters: Vectors = Vectors()
    private var numberOfPixels: Int = 0
    
    //Initialization
    init(_ K: Int = 1, _ _values: [UIColor] = [], _ maxInterator: Int = 700) {
        super.init()
        self.values = []
        self.k = min(K, _values.count)
        self.maxInterator = maxInterator
        for value in _values {
            self.addPixel(value)
        }
        self.currentClusters = Vectors(repeating: Vector(), count: self.k)
        self.oldClusters = Vectors(repeating: Vector(), count: self.k)
        if self.k >= 1 {
            self.oldClusters[0] = self.values
        }
        //Initializing centroids
        for i in 0 ..< self.k {
            self.centroids.append(_values[i])
        }
        //Performing clustering
        self.clustering()
    }
    // Check if k-mean clustering could stop
    private func couldStop(_ interator: Int) -> Bool {
        if interator > self.maxInterator {
            self.finalClusters = self.oldClusters
            return false
        }
        for i in 0 ..< self.k {
            let oldCluster = self.oldClusters[i]
            let currentCluster = self.currentClusters[i]
            let oldL = oldCluster.count
            let curL = currentCluster.count
            if oldL != curL {
                return true
            }
            else {
                for j in 0 ..< oldL {
                    let oldPixel = oldCluster[j]
                    if !currentCluster.contains(oldPixel) {
                        return true
                    }
                }
            }
        }
        self.finalClusters = self.oldClusters
        return false
    }
    //Adding an pixel to data
    func addPixel(_ p: UIColor) {
        self.values.append(p)
        self.numberOfPixels = self.numberOfPixels + 1
    }
    
    //Updating new centroids
    private func updateCentroids () {
        for i in 0 ..< self.k {
            self.centroids[i] = self.currentClusters[i].average
        }
    }
    
    //Running clustering in data
    private func clustering() {
        var count = 0
        while self.couldStop(count) {
            count = count + 1
            
            //reset current clusters
            self.currentClusters = Vectors(repeating: Vector(), count: self.k)
            //run over each pixel in values
            for i in 0 ..< self.numberOfPixels {
                var distance = 9999.0
                let pixel = self.values[i]
                var inCluster = 0
                //run over each centroid
                for j in 0 ..< self.k {
                    let centroid = self.centroids[j]
                    let newDistance = pixel.distance(centroid)
                    //get the closest distance
                    if newDistance < distance {
                        distance = newDistance
                        inCluster = j
                    }
                    self.currentClusters[inCluster].append(pixel)
                }
            }
            self.updateCentroids()
            self.oldClusters = self.currentClusters
        }
    }
    
    //Return final Cluster
    public var getClusters: Vectors {
        get {
            return self.finalClusters
        }
    }
    
    public var mostDominantColor: UIColor? {
        guard let r = self.centroids.first else { return nil }
        return r
        
    }
    
    public var secondDominantColor: UIColor! {
        get {
            guard let r: UIColor = self.centroids[1] else { return nil }
            return r
        }
    }
}
