//
//  Helper.swift
//  FoodProject
//
//  Created by Admin on 04/04/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Helper
{
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}



