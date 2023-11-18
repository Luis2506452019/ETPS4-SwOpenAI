//
//  TextMessageView.swift
//  SwOpenAI
//
//  Created by MacOsX on 18/11/23.
//

import SwiftUI
// Importamos nuestro framework
import SwiftOpenAI

struct TextMessageView: View {
    //Mensaje que queremos mostrar
    var message: MessageChatGPT
    
    var body: some View {
        HStack{
            
            if message.role == .user {
                Spacer()
                Text(message.text)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue)
                    )
                    .frame(maxWidth: 240, alignment: .trailing)
            } else {
                Text(message.text)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray)
                    )
                    .frame(maxWidth: 240, alignment: .leading)
                Spacer()
            }
            
        }
    }
}

struct TextMessageView_Previews: PreviewProvider {
    // Creamos 2 previews (msj de nosotros y msj que vamos a recibir)
    static let ChatGPTMessage: MessageChatGPT = .init(text: "Hola SwiftBeta, estoy aquì para ayudarte y contestar todas tus preguntas", role: .system)
    
    static let myMessage: MessageChatGPT = .init(text: "¿Cuando se lanzo el primer mac mini?", role: .user)
    
    static var previews: some View {
        Group{
            // Usamos Preview para diferenciar cual es de GPT y la de nosotros
            TextMessageView(message: Self.ChatGPTMessage).previewDisplayName("ChatGPT Message")
            TextMessageView(message: Self.myMessage)
                .previewDisplayName("My Message")
        }
        // Para que solo se vea la view de lo que estamos trabajando
        .previewLayout(.sizeThatFits)
    }
}
