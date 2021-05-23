//
//  ViewController.swift
//  ArcView
//
//  Created by Gokhan Mutlu on 22.05.2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
         ArcView is added to Storyboard in order to see the drawing result while coding.
         You can also comment the following line and set the storyboard view enabled.
         */
        view.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2588235294, blue: 0.3019607843, alpha: 1)
        drawArcView()
    }
    
    
    func drawArcView(){
        
        let arcView = GMArcView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
        arcView.translatesAutoresizingMaskIntoConstraints = false
        arcView.backgroundColor = .clear
        arcView.data = ArcData.all()
        view.addSubview(arcView)
        
        
        NSLayoutConstraint.activate([
            arcView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            arcView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            arcView.widthAnchor.constraint(equalToConstant: arcView.bounds.width),
            arcView.heightAnchor.constraint(equalToConstant: arcView.bounds.height),
        ])
    }
    


}

