//
//  PulseResults.swift
//  SwiftPulseCast
//
//  Created by Jeremiah Poisson on 5/7/17.
//  Copyright © 2017 Jeremiah Poisson. All rights reserved.
//

import Foundation

public typealias PulseData = [String: Any]
public typealias PulseCompletion<T> = ((PulseResults<T>) -> Void)
public struct PulseResults<Value> {
	public var error : PulseNetworkError?
	public var result : Value?
	
	public var succeeded : Bool {
		get {
			return self.error == nil && result != nil
		}
	}
	
	public var failed : Bool {
		get {
			return !self.succeeded
		}
	}
}
