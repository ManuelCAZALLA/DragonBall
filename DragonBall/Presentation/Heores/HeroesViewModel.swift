//
//  HeroesViewModel.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 18/10/23.
//

import Foundation
import CoreData



class HeroesViewModel: HeroesViewControllerDelegate {
    
    // MARK: - Dependencies
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }
    private var heroes: Heroes = []
    
    // MARK: Inits
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        DispatchQueue.global().async {
            defer {self.viewState?(.loading(false))}
            guard let token = self.secureDataProvider.getToken() else {return}
            
            self.apiProvider.getHeroes(
                by: nil,
                token: token) { heroes in
                    self.heroes = heroes
                    
                    let moc = CoreDataStack.shared.persistentContainer.viewContext
                    let entityHero = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
                    
                    let heroDao = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
                    
                    self.viewState?(.updateData)
                }
        }
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount { // Primero compruebo que existe
            heroes[index]
        }else {
            nil
        }
    }
}
