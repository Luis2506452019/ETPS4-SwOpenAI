//
//  ViewModel.swift
//  SwOpenAI
//
//  Created by MacOsX on 17/11/23.
//

import Foundation
// Importamos Framework descargado de github.com/SwiftBeta/SwiftOpenAI
import SwiftOpenAI

// Agregamos un ObservableObject para solucionar el error del ConversationView
final class ViewModel: ObservableObject{
    
    // Creamos una propiedad que contenga la red de msjs
    @Published var messages: [MessageChatGPT] = [
        .init(text: "¡Hola! Soy el asistente de SwiftBeta, estoy aquí para contestarte todas las preguntas relacionadas de Swift, SwiftUI, Xcode ¡y mucho más!", role: .system)
    ]
    // Referencia a todos los msj que recibiremos de GPT en un unico msj
    @Published var currentMessage: MessageChatGPT = .init(text: "", role: .assistant)
    
    // Primero inicializamos OpenAI con una clave API, para asi utilizar las funciones del SDK
    // La clave API la obtenemos de platform.openai.com
    var openAI = SwiftOpenAI(apiKey: "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")
    
    // Agrupamos en un metodo para solucionar el error que da por defecto al pegar el codigo del repositorio
    // Message -> msj que envia el user
    func send(message: String) async{
        
        // (Parametros a personalizar para crear la peticion)
        // Existe una clase en el SDK que se encarga de hacer la peticion HTTP y retornarnos los datos
        let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.7, stream: true, maxTokens: 200) //Aumentamos el maxTokens, por defecto 50
        
        // Para que se ejecute en el hilo principal
        await MainActor.run{
            // Convertimos nuestro msj a MessageChatGPT
            let myMessage = MessageChatGPT(text: message, role: .user)
            // Lo añadimos al array creado
            self.messages.append(myMessage)
            
            // Msj vacio, no sabemos que retornara GPT
            self.currentMessage = MessageChatGPT(text: "", role: .assistant)
            // Lo añadimos a la red de msj
            self.messages.append(self.currentMessage)
        }

        // Los datos los obtenemos a traves del Do
        do {
            // Le decimos al SDK como queremos obtener la informacion de la pregunta que le realizamos a GPT
            // La API de GPT tiene varios formatos
            
            // 1. Pregunta, lo procesa y despues de unos segundos obtenemos respuesta
            // 2. Pregunta, GPT va contestando mientras lo esta procesando y recibimos fragmentos de esa respuesta (Esta opcion usaremos)
            
            let stream = try await openAI.createChatCompletionsStream(model: .gpt4(.base),
                                                                      messages: messages,
                                                                      optionalParameters: optionalParameters)
            
            // Cada vez que se ejecuta el for es porque recibimos un valor del String de GPT
            for try await response in stream {
                print(response)
                await onReceive(newMessage: response)
            }
            // Catch por posibles errores
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Actualizar el msj que nos va retornando GPT y verlo desde nuestra vista
    @MainActor
    private func onReceive(newMessage: ChatCompletionsStreamDataModel) {
        // Guardamos la info en una constante
        let lastMessage = newMessage.choices[0]
        
        // No sea un Stop y no se finalice el string para continuar
        guard lastMessage.finishReason == nil else {
            print("Finished streaming messages")
            return
        }
        
        // Si tiene datos, los tomamos
        guard let content = lastMessage.delta?.content else {
            print("message with no content")
            return
        }
         // Concatenamos el contenido
        currentMessage.text = currentMessage.text + content
        // Actualizamos el ultimo msj de nuestro array
        messages[messages.count - 1].text = currentMessage.text
    }
    
}
