//
//  BackgroundView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 03.02.21.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color(UIColor.systemBackground))
            .shadow(radius: 3)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
