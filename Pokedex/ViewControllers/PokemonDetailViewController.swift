//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Eduardo Varela on 04/02/19.
//  Copyright © 2019 Eduardo Varela. All rights reserved.
//

import UIKit
import Reachability

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var abilitiesTableView: UITableView!

    var activityIndicator: UIActivityIndicatorView? = nil
    var pokemonUrl: String = ""
    var abilitiesList: [PokemonAbilityData] = []
    let reachability = Reachability()!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidReceivePokemonTypeData(notification:)), name: .didReceivePokemonData, object: nil)

        // Create the Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: .gray)
        // Add it to the view
        view.addSubview(activityIndicator!)
        // Set up its size
        activityIndicator?.frame = view.bounds
        // Start the loading animation
        activityIndicator?.startAnimating()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTextButton))
        
        self.title = "Loading..."
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        self.pokemonImage.layer.cornerRadius = self.pokemonImage.frame.width / 2
    }
    
    @objc func onDidReceivePokemonTypeData(notification:Notification) {
        
        if let data = notification.userInfo as? [String : PokemonDetailData]
        {
            if let pokemonData: PokemonDetailData = data["pokemonData"]{
                self.title = pokemonData.name.capitalized
                pokemonImage.image = PokemonDataManager.downloadImage(from: pokemonData.sprites.front_default)
                pokemonImage.backgroundColor = .white
                pokemonName.text = pokemonData.name.capitalized
                pokemonHeight.text = "Height: \(pokemonData.height)"
                pokemonWeight.text = "Width: \(pokemonData.weight)"
                pokemonData.abilities.forEach { (pokemonAbilityDataContainer) in
                    self.abilitiesList.append(pokemonAbilityDataContainer.ability)
                }
                self.abilitiesTableView.reloadData()
                self.activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    // share text
    @IBAction func shareTextButton(_ sender: UIButton) {
        // set up activity view controller
        var stringAbilities = ""
        abilitiesList.forEach { (pokemonAbility) in
            stringAbilities += "\(pokemonAbility.name.capitalized)\n"
        }
        
        let textToShare = ["[Pokemon]\nName: \(pokemonName.text!)\nHeight: \(pokemonHeight.text!)\nWeight: \(pokemonWeight.text!)\nAbilities:\n\(stringAbilities)"]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        
        if reachability.connection != .none{
            if (abilitiesList.isEmpty){
                PokemonDataManager.pokemonData(url: pokemonUrl)
            }
        }
    }
}

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilitiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonAbilityCell", for: indexPath)
        cell.textLabel?.text = abilitiesList[indexPath.row].name.capitalized
        cell.textLabel?.textColor = UIColor(red: 248/255.0, green: 12/255.0, blue: 49/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor(red: 248/255.0, green: 12/255.0, blue: 49/255.0, alpha: 1.0)

        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 16, height: 30))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Abilities"
        headerView.addSubview(label)
        return headerView
    }
}
