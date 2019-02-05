//
//  PokemonDataManager.swift
//  Pokedex
//
//  Created by Eduardo Varela on 03/02/19.
//  Copyright © 2019 Eduardo Varela. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDataManager: NSObject {

    static func pokemonTypeList(){
        
        Alamofire.request("https://pokeapi.co/api/v2/type").responseJSON { response in

                if let data = response.data{
                    if response.error != nil{
                        return
                    }
                    
                    if let responseData: PokemonTypeRequestResponse = try? JSONDecoder().decode(PokemonTypeRequestResponse.self, from: data){
                        
                        NotificationCenter.default.post(name: .didReceivePokemonTypeList, object: self, userInfo: ["pokemonTypeList": responseData.results])
                    }
                }
        }
    }
    
    static func pokemonTypeData(url: String){
        
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data{
                if response.error != nil{
                    return
                }
                
                if let responseData: PokemonTypeDataParser = try? JSONDecoder().decode(PokemonTypeDataParser.self, from: data){
                    var typeData: PokemonTypeData = PokemonTypeData(name: responseData.name, pokemon: [])
                    
                    responseData.pokemon.forEach({ (pkmnTypeData) in
                        typeData.pokemon.append(pkmnTypeData.pokemon)
                    })
                    
                    NotificationCenter.default.post(name: .didReceivePokemonTypeData, object: self, userInfo: ["pokemonTypeData": typeData])
                }
            }
        }
    }
    
    static func pokemonData(url: String){
        
        Alamofire.request(url).responseJSON { response in
            
            if let data = response.data{
                if response.error != nil{
                    return
                }
                
                if let responseData: PokemonDetailData = try? JSONDecoder().decode(PokemonDetailData.self, from: data){
                    NotificationCenter.default.post(name: .didReceivePokemonData, object: self, userInfo: ["pokemonData": responseData])
                }
            }
        }
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    static func downloadImage(from urlString: String) -> UIImage {
        let urlImage = URL(string: urlString)
        if let imageData = try? Data(contentsOf: urlImage!){
            let coverImage = UIImage(data: imageData)
            return coverImage!
        }
        return UIImage()
    }
}

struct PokemonTypeRequestResponse: Codable{
    let count: Int
    let results: [PokemonType]
}

struct PokemonTypeDataRequestResponse: Codable{
    let pokemon: PokemonData
}

struct PokemonType: Codable{
    let name: String
    let url: String
}

struct PokemonTypeDataParser: Codable{
    let name: String
    let pokemon: [PokemonTypeDataRequestResponse]
}

struct PokemonTypeData: Codable{
    let name: String
    var pokemon: [PokemonData]
}
                
struct PokemonData: Codable{
    let name: String
    let url: String
}

struct PokemonDetailData: Codable{
    let name: String
    let height: Int
    let weight: Int
   let abilities: [PokemonAbilityDataContainer]
    let sprites: PokemonImageData
}

struct PokemonAbilityDataContainer: Codable{
    let ability: PokemonAbilityData
}

struct PokemonAbilityData: Codable{
    let name: String
}

struct PokemonImageData: Codable{
    let front_default: String
}
