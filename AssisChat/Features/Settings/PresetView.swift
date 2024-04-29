//
//  PresetView.swift
//  AssisChat
//  Created by JoyTim on 2024/4/29
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

struct PresetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section() {
                ForEach(ChatPreset.presets, id: \.name) { preset in
                    PresetItem(preset: preset)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            dismiss()
                        }
                }
            }

        }.background(Color.groupedBackground)
        .navigationTitle("Preset view Setting")
    }
}

#Preview {
    PresetView()
}
