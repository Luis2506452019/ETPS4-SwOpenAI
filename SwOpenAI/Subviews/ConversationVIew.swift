//
//  ConversationVIew.swift
//  SwOpenAI
//
//  Created by MacOsX on 18/11/23.
//

import SwiftUI

struct ConversationVIew: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.messages){
                message in TextMessageView(message: message)
            }
        }
    }
}

struct ConversationVIew_Previews: PreviewProvider {
    static var previews: some View {
        // Pasamos una instancia del ViewModel para ver la vista de lo que estamos construyendo
        ConversationVIew().environmentObject(ViewModel())
    }
}
