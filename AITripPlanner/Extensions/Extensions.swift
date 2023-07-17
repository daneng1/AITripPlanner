//
//  Extensions.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/16/23.
//

import Foundation
import SwiftUI

extension View {
    func hidekeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}

extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }
