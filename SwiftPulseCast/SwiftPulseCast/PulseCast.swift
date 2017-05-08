//
//  PulseCast.swift
//  SwiftPulseCast
//
//  Created by Jeremiah Poisson on 5/7/17.
//  Copyright © 2017 Jeremiah Poisson. All rights reserved.
//

import Foundation

enum PulseError : Error {
	case CoreURLError
	case MissingSubscriptionKeyError
}

/**
Core Pulse Cast class. 

Create and configure an instance of this class to interact with the EarthNetworks Pulse API
so you can retrieve various weather data.

In order to configure and use this framework you must obtain a subscription key from 
[EarthNetworks](https://login.enterprise.earthnetworks.com/)
*/
public class PulseCast {
	
	/// The subscription key obtained from [EarthNetworks](https://login.enterprise.earthnetworks.com/)
	var subscriptionKey : String?
	
	/**
	Initializes the PulseCast framwork.
	
	- parameter subscriptionKey: The subscription key obtained from [EarthNetworks](https://login.enterprise.earthnetworks.com/)
	*/
	public required convenience init(subscriptionKey: String) {
		self.init()
		self.subscriptionKey = subscriptionKey
	}
	
	/**
	Almanac Data provides accurate sunrise and sunset times based on latitude and longitude.
	
	- parameters:
		- coordinates: CLLocationCoordinate2D
	*/
	public func almanacData(coordinates: PulseLocation, verbose: Bool = true, days: Int = 1, cultureInfo: String = "en-us", completion: @escaping PulseCompletion<PulseData>) throws {
		
		guard self.subscriptionKey != nil else {
			throw PulseError.MissingSubscriptionKeyError
		}
		
		guard let url = Endpoints.almanacData.getURL() else {
			throw PulseError.CoreURLError
		}
		
		let params : Parameters = [
			"locationtype": "latitudelongitude",
			"location": coordinates.toString(),
			"days": days,
			"verbose": verbose ? "true" : "false",
			"cultureInfo": cultureInfo
		]
		
		let headers : HTTPHeaders = [
			"Ocp-Apim-Subscription-Key": self.subscriptionKey!
		]
		
		request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200...299).responseJSON { (response: DataResponse<Any>) in
			
			print(response)
			
			guard let pulseResponse = response.result.value as? PulseData else {
				completion(PulseResults(error: PulseNetworkError.InvalidResponse, result: nil))
				return
			}
			
			completion(PulseResults(error: nil, result: pulseResponse))
			
		}
		
	}
	
	public func currentWeather(coordinates: PulseLocation, verbose: Bool = true, units: String = "Metric", cultureInfo: String = "en-us", ruledetails: Bool = false, metadata: Bool = false, includeqcflags: Bool = false, completion: @escaping PulseCompletion<PulseData>) throws {
		
		guard self.subscriptionKey != nil else {
			throw PulseError.MissingSubscriptionKeyError
		}
		
		guard let url = Endpoints.currentWeather.getURL() else {
			throw PulseError.CoreURLError
		}
		
		let params : Parameters = [
			"locationtype": "latitudelongitude",
			"location": coordinates.toString(),
			"verbose": verbose ? "true" : "false",
			"cultureInfo": cultureInfo,
			"units": units,
			"ruledetails": ruledetails ? "true" : "false",
			"metadata": metadata ? "true" : "false",
			"includeqcflags": includeqcflags ? "true" : "false"
		]
		
		let headers : HTTPHeaders = [
			"Ocp-Apim-Subscription-Key": self.subscriptionKey!
		]
		
		request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200...299).responseJSON { (response: DataResponse<Any>) in
			
			print(response)
			
			guard let pulseResponse = response.result.value as? PulseData else {
				completion(PulseResults(error: PulseNetworkError.InvalidResponse, result: nil))
				return
			}
			
			completion(PulseResults(error: nil, result: pulseResponse))
			
		}
		
	}
	
}
