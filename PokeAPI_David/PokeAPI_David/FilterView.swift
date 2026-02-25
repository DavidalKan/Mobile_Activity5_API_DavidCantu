//
//  FilterView.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 24/02/26.
//
// FilterView para separar los pokemon por regiones

import SwiftUI

struct FilterView: View {
    @State private var pokemonVM = PokemonViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    
    let generations = [
        ("1ra Gen (Kanto)", 0, 151),
        ("2da Gen (Johto)", 151, 100),
        ("3ra Gen (Hoenn)", 251, 135),
        ("4ta Gen (Sinnoh)", 386, 107)
    ]
    
    // Resultados filtrados globalmente
    var globalSearchResults: [PokemonEntry] {
        pokemonVM.allPokemonForSearch.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        List {
            if !searchText.isEmpty {
                // --- RESULTADOS DE BÚSQUEDA GLOBAL ---
                Section(header: Text("Resultados de búsqueda")) {
                    if globalSearchResults.isEmpty {
                        Text("No se encontró ningún Pokémon con '\(searchText)'")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(globalSearchResults) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                PokemonRowView(pokemon: pokemon)
                            }
                        }
                    }
                }
            } else {
                // --- VISTA NORMAL DE GENERACIONES ---
                Section(header: Text("Explorar por Región")) {
                    ForEach(generations, id: \.0) { gen in
                        NavigationLink(destination: PokeListView(genTitle: gen.0, offset: gen.1, limit: gen.2)) {
                            Label(gen.0, systemImage: "map.fill")
                        }
                    }
                }
            }
        }
        .navigationTitle("Pokédex")
        .searchable(text: $searchText, prompt: "Buscar Pokémon...")
        // Lógica Global en .onChange
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                isSearching = true
                print("Buscando globalmente: \(newValue)")
            } else {
                isSearching = false
            }
        }
        .task {
            // Cargamos la lista de búsqueda al aparecer la vista
            await pokemonVM.loadSearchList()
        }
    }
}
