//
//  PokeViewModel.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 23/02/26.
//

import Foundation

// MVVM: El ViewModel actúa como el cerebro de la aplicación, manejando el estado y la lógica de red fuera de la vista.
@MainActor
@Observable
class PokemonViewModel {
    var arrPokemon = [PokemonEntry]()          // Datos para la lista de una generación específica
    var allPokemonForSearch = [PokemonEntry]() // Base de datos local para búsqueda global instantánea
    var currentPokemonDetail: PokemonDetail?   // Almacena tipos y stats del Pokémon seleccionado
    var weaknesses = [String]()                // Lista de debilidades procesada
    var isLoading = false                      // User Feedback: Indica si hay una operación de red en curso
    
    
    /// Carga una lista base de Pokémon al iniciar la app para que el buscador global en FilterView sea fluido.
    /// Aplicamos "Single Responsibility": Esta función solo prepara los datos de búsqueda.
    func loadSearchList() async {
        guard allPokemonForSearch.isEmpty else { return }
        isLoading = true
        
        do {
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=251") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            self.allPokemonForSearch = decoded.results
        } catch {
            print("Error en búsqueda global: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    /// Obtiene los Pokémon de una generación específica mediante paginación (offset y limit).
    /// Robust Error Handling: Implementa validación de respuesta y manejo de errores asíncronos.
    func getPokemonByGeneration(offset: Int, limit: Int) async throws {
        self.isLoading = true
        // Clean Code: Usamos defer para asegurar que el loading se apague sin importar el resultado del request.
        defer { self.isLoading = false }
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        self.arrPokemon = decodedResponse.results
    }
    
    /// Obtiene los detalles de un Pokémon y encadena una segunda petición para obtener sus debilidades.
    /// Code Documentation: Se procesa la relación de daño (damage_relations) para extraer las debilidades x2.
    func getDetailsAndWeaknesses(for pokemon: PokemonEntry) async {
        self.currentPokemonDetail = nil
        self.weaknesses = []
        
        do {
            // 1. Obtener Tipos del Pokémon
            guard let detailURL = URL(string: pokemon.url) else { return }
            let (data, _) = try await URLSession.shared.data(from: detailURL)
            let detail = try JSONDecoder().decode(PokemonDetail.self, from: data)
            self.currentPokemonDetail = detail
            
            // 2. Obtener Debilidades del primer tipo encontrado
            if let typeURLString = detail.types.first?.type.url,
               let typeURL = URL(string: typeURLString) {
                let (typeData, _) = try await URLSession.shared.data(from: typeURL)
                let typeInfo = try JSONDecoder().decode(TypeDetail.self, from: typeData)
                
                // Extraemos solo los nombres de los tipos que hacen daño doble
                self.weaknesses = typeInfo.damage_relations.double_damage_from.map { $0.name }
            }
        } catch {
            print("Error al obtener detalles/debilidades: \(error)")
        }
    }
}
