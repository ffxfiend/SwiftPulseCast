//
//  PulseLocation.swift
//  SwiftPulseCast
//
//  Created by Jeremiah Poisson on 5/7/17.
//  Copyright © 2017 Jeremiah Poisson. All rights reserved.
//

import Foundation

public struct PulseLocation {
	
	public var latitude : Double = 0.0
	public var longitude : Double = 0.0
	
	public init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	func toString() -> String {
		return "\(self.latitude),\(self.longitude)"
	}
	
}
