//
//  NotificationExtension.swift
//  Pokedex
//
//  Created by Eduardo Varela on 04/02/19.
//  Copyright © 2019 Eduardo Varela. All rights reserved.
//

import Foundation
//MARK: Notifications
extension Notification.Name{
    static let didReceivePokemonTypeList = Notification.Name("didReceivePokemonTypeList")
    static let didReceivePokemonTypeData = Notification.Name("didReceivePokemonTypeData")
    static let didReceivePokemonData = Notification.Name("didReceivePokemonData")
}
