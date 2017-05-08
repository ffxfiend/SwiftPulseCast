//
//  PulseResults.swift
//  SwiftPulseCast
//
//  Created by Jeremiah Poisson on 5/7/17.
//  Copyright © 2017 Jeremiah Poisson. All rights reserved.
//

import Foundation

public typealias PulseCompletion<T> = ((PulseResults<T>) -> Void)
public struct PulseResults<Value> {
	var error : PulseNetworkError?
	var result : Value?
	
	var succeeded : Bool {
		get {
			return self.error == nil && result != nil
		}
	}
	
	var failed : Bool {
		get {
			return !self.succeeded
		}
	}
}
