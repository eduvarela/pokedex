//
//  PokemonTypeViewController.swift
//  Pokedex
//
//  Created by Eduardo Varela on 03/02/19.
//  Copyright © 2019 Eduardo Varela. All rights reserved.
//

import UIKit
import Reachability

class PokemonTypeViewController: UIViewController {
    
    @IBOutlet weak var pokemonTypeCollectionView: UICollectionView!

    var pokemonTypes: [PokemonType] = []
    var selectedItem: Int = 0
    var activityIndicator: UIActivityIndicatorView? = nil
    let reachability = Reachability()!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //notification observer for pictures update
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidReceivePokemonTypeList(notification:)), name: .didReceivePokemonTypeList, object: nil)
        
        self.title = "Pokémon Types"
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }

        // Create the Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .gray)
        // Add it to the view
        view.addSubview(activityIndicator!)
        // Set up its size
        activityIndicator?.frame = view.bounds
        // Start the loading animation
        activityIndicator?.startAnimating()
        
        PokemonDataManager.pokemonTypeList()
    }
    
    
    //function that update picture list after receiving them
    @objc func onDidReceivePokemonTypeList(notification:Notification) {
        
        if let data = notification.userInfo as? [String : [PokemonType]]
        {
            if let pokemonTypeList: [PokemonType] = data["pokemonTypeList"]{
                self.pokemonTypes = pokemonTypeList.filter({$0.name != "unknown" && $0.name != "shadow"})
                pokemonTypeCollectionView.reloadData()
                self.activityIndicator?.removeFromSuperview()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonList"{
            let pkmnListViewController: PokemonListViewController = segue.destination as! PokemonListViewController
            pkmnListViewController.typeUrl = pokemonTypes[selectedItem].url
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        
        if reachability.connection != .none{
            if (pokemonTypes.isEmpty){
                PokemonDataManager.pokemonTypeList()
            }
        }
    }
}

extension PokemonTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonTypeCell", for: indexPath)
        
        if let typeImage = cell.viewWithTag(1) as? UIImageView{
            typeImage.image = UIImage(named: "\(pokemonTypes[indexPath.row].name)Type")
            
            typeImage.layer.borderWidth = 1
            typeImage.layer.masksToBounds = false
            typeImage.layer.borderColor = UIColor.black.cgColor
            typeImage.layer.cornerRadius = typeImage.frame.height/2
            typeImage.clipsToBounds = true

        }
        
        if let typeLabel = cell.viewWithTag(2) as? UILabel{
            typeLabel.text = pokemonTypes[indexPath.row].name.capitalized
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        performSegue(withIdentifier: "pokemonList", sender: self)
    }
}

