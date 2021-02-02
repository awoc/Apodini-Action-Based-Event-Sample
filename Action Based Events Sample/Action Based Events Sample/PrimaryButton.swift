//
//  Button.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI

struct PrimaryButton : View {
    var text = "Save"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 55)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .foregroundColor(Color("Primary"))
            Text(text)
                .bold()
                .foregroundColor(Color.white)
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton()
    }
}
