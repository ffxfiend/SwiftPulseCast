//
//  EndPoints.swift
//  SwiftPulseCast
//
//  Created by Jeremiah Poisson on 5/7/17.
//  Copyright © 2017 Jeremiah Poisson. All rights reserved.
//

import Foundation

let APIBaseURL : String = "https://earthnetworks.azure-api.net/"

enum Endpoints : String {
	
	case almanacData = "getAlmanacData/data/almanac/v1"
	
	case skyConditionsIcons = "getSkyConditionIcons/resources/v3/icons"
	
	case tenDayNightForcast = "data/forecasts/v1/daily"
	
	case currentWeather = "data/observations/v4/current"
	
	// MARK: - Helper Methods
	func buildURLString(_ params: [String]) -> String {
		
		var rawString = self.rawValue
		for (idx, value) in params.enumerated() {
			guard let valueEncoded = value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
				continue
			}
			
			rawString = rawString.replacingOccurrences(of: "{\(idx)}", with: "\(valueEncoded)")
		}
		
		return "\(APIBaseURL)\(rawString)"
	}
	
	func getURL(_ params: [String] = []) -> URL? {
		
		let urlString = self.buildURLString(params)
		guard let url = URL(string: urlString) else {
			return nil
		}
		return url
		
	}
	
}

