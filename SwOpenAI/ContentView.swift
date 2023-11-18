//
//  ContentView.swift
//  SwOpenAI
//
//  Created by MacOsX on 17/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    // Msj del user, enviado a GPT
    @State var prompt: String = "Por favor, dime un resumen de Game of Thrones (Juego de Tronos)"
    
    var body: some View {
        VStack {
            ConversationVIew()
                .environmentObject(viewModel)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                TextField("Escribe la pregunta a ChatGPT",
                          text: $prompt,
                          axis: .vertical)
                .padding(12)
                .background (Color(.systemGray6))
                .cornerRadius(25)
                .lineLimit (6)
                Button {
                    Task {
                        await viewModel.send(message: prompt)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.white)
                        .frame(width: 44, height: 44)
                        .background (Color.blue)
                        .cornerRadius(22)
                }
                .padding(.leading, 8)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
