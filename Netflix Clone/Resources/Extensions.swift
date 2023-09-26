//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Fredrick on 24/09/2023.
//

import Foundation

extension String{
    func capitalizationfilter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
