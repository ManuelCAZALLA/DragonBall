//
//  HeroCell.swift
//  DragonBall
//
//  Created by Manuel Cazalla Colmenero on 18/10/23.
//

import UIKit
import Kingfisher

class HeroCellView: UITableViewCell {
    static let identifier = "HeroCellView"
    static let estimatedHeight = 256
    
    // IBOutlets
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var descriptionHero: UILabel!
    @IBOutlet weak var imageHero: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Esto se hace para que al hacer scroll las imagenes que no se ven no salgan con datos de otras vistas
        nameHero.text = nil
        descriptionHero.text = nil
        imageHero.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emptyView.layer.cornerRadius = 8
        emptyView.layer.shadowColor = UIColor.gray.cgColor
        emptyView.layer.shadowOffset = .zero
        emptyView.layer.shadowRadius = 8
        emptyView.layer.shadowOpacity = 0.4
        
        imageHero.layer.cornerRadius = 8
        imageHero.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        selectionStyle = .none // No hacer efecto seleccionado de celda
        
        
    }
    
    func updateView(
        name: String? = nil,
        imageHero: String? = nil,
        description: String? = nil) 
    {
        self.nameHero.text = name
        self.descriptionHero.text = description
        self.imageHero.kf.setImage(with: URL(string: imageHero ?? ""))
        
    }
}
