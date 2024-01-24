//
//  ReturnEntity+CoreDataClass.swift
//  financecontrol
//
//  Created by PinkXaciD on R 5/11/30.
//
//

import Foundation
import CoreData

@objc(ReturnEntity)
public final class ReturnEntity: NSManagedObject, Codable {
    public enum CodingKeys: CodingKey {
        case id, amount, amountUSD, name, currency, date
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.moc] as? NSManagedObjectContext else {
            throw URLError(.badURL)
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.amountUSD = try container.decode(Double.self, forKey: .amountUSD)
        self.name = try container.decode(String.self, forKey: .name)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.date = try container.decode(Date.self, forKey: .date)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(amount, forKey: .amount)
        try container.encode(amountUSD, forKey: .amountUSD)
        try container.encode(name, forKey: .name)
        try container.encode(currency, forKey: .currency)
        try container.encode(date, forKey: .date)
    }
}
