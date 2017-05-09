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
		- coordinates: Location to use for querying data from the system.
		- verbose: Determines if the feed should return parameters names as full text or abbreviations.  **Defaults to true**
		- days: Number of days you want data for. The default is 1 meaning only the current day. The number of days includes the current day and any subsequent days in local time (max:10).  **Defaults to 1**
		- cultureInfo: Determines in which language to return results. **Defaults to en-us**
		- completion: Code to be called when the network request is complete.
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
	
	/**
	Current condition data based on the location requested.
	
	- parameters:
		- coordinates: Location to use for querying data from the system.
		- verbose: Determines if the feed should return parameters names as full text or abbreviations. **Defaults to true**
		- unit: Return data using Metric or English units. **Defaults to .metric**
		- cultureInfo: Determines in which language to return results. **Defaults to en-us**
		- ruleDetails: Determines whether or not to display explanation of rollover logic. **Defaults to false**
		- metaData: Determines whether or not to return metadata. **Defaults to false**
		- includeQCFlags: Provides QC value for filtered measurements. **Defaults to false**
		- completion: Code to be called when the network request is complete.
	*/
	public func currentWeather(coordinates: PulseLocation, verbose: Bool = true, unit: PulseUnit = .metric, cultureInfo: String = "en-us", ruleDetails: Bool = false, metaData: Bool = false, includeQCFlags: Bool = false, completion: @escaping PulseCompletion<PulseData>) throws {
		
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
			"units": unit.rawValue,
			"ruledetails": ruleDetails ? "true" : "false",
			"metadata": metaData ? "true" : "false",
			"includeqcflags": includeQCFlags ? "true" : "false"
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
