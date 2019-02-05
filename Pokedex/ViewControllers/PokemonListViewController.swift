//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Eduardo Varela on 04/02/19.
//  Copyright © 2019 Eduardo Varela. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController {
    var typeUrl: String = ""
    var pokemonList: [PokemonData] = []
    var selectedItem: Int = 0

    var activityIndicator: UIActivityIndicatorView? = nil
    @IBOutlet weak var pokemonListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidReceivePokemonTypeData(notification:)), name: .didReceivePokemonTypeData, object: nil)
        
        // Create the Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .gray)
        // Add it to the view
        view.addSubview(activityIndicator!)
        // Set up its size
        activityIndicator?.frame = view.bounds
        // Start the loading animation
        activityIndicator?.startAnimating()
        
        PokemonDataManager.pokemonTypeData(url: typeUrl)
    }
    
    @objc func onDidReceivePokemonTypeData(notification:Notification) {
        
        if let data = notification.userInfo as? [String : PokemonTypeData]
        {
            if let pokemonTypeData: PokemonTypeData = data["pokemonTypeData"]{
                pokemonList = pokemonTypeData.pokemon
                self.title = pokemonTypeData.name.capitalized
                self.pokemonListTableView.reloadData()
                self.activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetail"{
            let pkmnViewController: PokemonDetailViewController = segue.destination as! PokemonDetailViewController
            pkmnViewController.pokemonUrl = pokemonList[selectedItem].url
        }
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = pokemonList[indexPath.row].name
        cell.textLabel?.textColor = UIColor(red: 248/255.0, green: 12/255.0, blue: 49/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        performSegue(withIdentifier: "pokemonDetail", sender: self)
    }
}
