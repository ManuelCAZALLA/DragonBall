//
//  HeroesViewController.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 18/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
       var heroesCount: Int { get }

       func onViewAppear()
       func heroBy(index: Int) -> Hero?
   }


enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    //MARK: - IBOuntlet -
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var heroesTableView: UITableView!
    
    // MARK: - Public Properties
    var viewModel: HeroesViewControllerDelegate?
    
    // MARK: - Lifecicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        viewModel?.onViewAppear()
       
    }
    
   
    
    // MARK: -Private Func -
    private func initViews() {
        heroesTableView.register(
            UINib(nibName: HeroCellView.identifier, bundle: nil),
            forCellReuseIdentifier: HeroCellView.identifier)
        
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
    }
    
    private func setObserver() {
        viewModel?.viewState = {[weak self ] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    
                case .updateData:
                    self?.heroesTableView.reloadData() // la tabla actualiza sus datos
                }
            }
        }
    }
}
// MARK: - Extension -
extension HeroesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(HeroCellView.estimatedHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCellView.identifier, for: indexPath) as? HeroCellView else {
            
            return UITableViewCell()
        }
        
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                imageHero: hero.photo,
                description: hero.description)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Navegar a detalle
    }
    
}




