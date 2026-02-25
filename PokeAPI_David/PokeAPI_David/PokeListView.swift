//
//  PokeListView.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 24/02/26.
//

import SwiftUI

struct PokeListView: View {
    // MVVM: Referencia al ViewModel que maneja la lógica de datos
    @State var pokemonVM = PokemonViewModel()
    @State private var searchText = ""
    
    // Parámetros recibidos de FilterView
    let genTitle: String
    let offset: Int
    let limit: Int
    
    // Clean Code: Propiedad computada para filtrar en tiempo real (Single Responsibility)
    var filteredPokemon: [PokemonEntry] {
        if searchText.isEmpty {
            return pokemonVM.arrPokemon
        } else {
            return pokemonVM.arrPokemon.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            // Capa principal: La lista de Pokémon
            List {
                ForEach(filteredPokemon) { pokemon in
                    NavigationLink {
                        PokemonDetailView(pokemon: pokemon)
                    } label: {
                        PokemonRowView(pokemon: pokemon)
                    }
                }
                
                // User Feedback: Rueda de carga al final de la lista durante el scroll
                if pokemonVM.isLoading && !pokemonVM.arrPokemon.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView("Cargando Pokémon...")
                            .padding()
                        Spacer()
                    }
                    .listRowSeparator(.hidden) // Limpieza visual
                }
            }
            
            // Robust Error Handling: Estado cuando no hay internet o la búsqueda falla
            if !searchText.isEmpty && filteredPokemon.isEmpty {
                ContentUnavailableView {
                    Label("No se encontró a '\(searchText)'", systemImage: "magnifyingglass")
                } description: {
                    Text("Intenta con otro nombre o revisa tu conexión.")
                }
            }
            
            // User Feedback: Loading central solo para la carga inicial
            if pokemonVM.isLoading && pokemonVM.arrPokemon.isEmpty {
                VStack(spacing: 15) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Consultando Pokédex...")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(genTitle)
        // Requerimiento: Barra de búsqueda integrada
        .searchable(text: $searchText, prompt: "Buscar en \(genTitle)")
        .task {
            // Llamada asíncrona a la API al aparecer la vista
            do {
                try await pokemonVM.getPokemonByGeneration(offset: offset, limit: limit)
            } catch {
                // Manejo de errores silencioso para evitar crashes
                print("Error de red: \(error.localizedDescription)")
            }
        }
    }
}

