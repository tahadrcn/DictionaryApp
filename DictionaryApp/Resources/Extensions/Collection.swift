//
//  Collection.swift
//  FinalHomework
//
//  Created by Tuba Uzun on 11.06.2024.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
  subscript (safe index: Index) -> Iterator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

