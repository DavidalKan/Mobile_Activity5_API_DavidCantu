//
//  Pokemon.swift
//  PokeAPI_David
//
//  Created by David Cantú Cabello on 24/02/26.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable {
    var id: String { name }
    let name: String
    let url: String
}

// Estructuras para el detalle del Pokémon (Tipos)
struct PokemonDetail: Codable {
    let types: [TypeEntry]
}

struct TypeEntry: Codable {
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String // Usaremos esta URL para buscar debilidades
}

// Estructura para las debilidades (Damage Relations)
struct TypeDetail: Codable {
    let damage_relations: DamageRelations
}

struct DamageRelations: Codable {
    let double_damage_from: [TypeInfo] // Estas son las debilidades
}
