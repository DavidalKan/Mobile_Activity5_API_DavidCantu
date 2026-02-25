//
//  PokeRowView.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 24/02/26.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: PokemonEntry
    
    var body: some View {
        HStack {
            let pokemonID = pokemon.url.split(separator: "/").last ?? "1"
            let thumbURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png"
            
            AsyncImage(url: URL(string: thumbURL)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            Text(pokemon.name.capitalized)
                .font(.headline)
        }
    }
}
