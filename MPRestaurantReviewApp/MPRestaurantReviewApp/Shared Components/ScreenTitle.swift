//
//  ScreenTitle.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import SwiftUI

struct ScreenTitle: View {
    var title = "Title"
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .padding(.top, 60)
    }
}

#Preview {
    ScreenTitle()
}
