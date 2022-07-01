//
//  JamItLocaleModel.swift
//  jamit
//
//  Created by Do Trung Bao on 27/04/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class JamItLocaleModel: JamitResponce {
    
    var countries: [LocaleModel]?
    var languages: [LocaleModel]?
    private var arrayLan: [String]?
    private var arrayCountries: [String]?
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.countries = self.parseListFromDict("countries")
        self.languages = self.parseListFromDict("languages")
    }
    func isEmptyLan() -> Bool {
        return languages?.isEmpty ?? true
    }
    
    func isEmptyCountry() -> Bool {
        return countries?.isEmpty ?? true
    }
    
    func getLanStrArrays() -> [String]? {
        if !isEmptyLan() && self.arrayLan == nil {
            var arrays:[String] = []
            languages?.forEach({ (model) in
                arrays.append(model.getFullName())
            })
            self.arrayLan = arrays
        }
        return arrayLan
    }
    
    func getCountryStrArrays() -> [String]? {
        if !isEmptyCountry() && self.arrayCountries == nil {
            var arrays:[String] = []
            countries?.forEach({ (model) in
                arrays.append(model.getFullName())
            })
            self.arrayCountries = arrays
        }
        return self.arrayCountries
    }
    
}
