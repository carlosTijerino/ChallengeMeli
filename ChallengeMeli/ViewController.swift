//
//  ViewController.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 13/04/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hola")
        
        let delayTime = DispatchTime.now() + 3.0
          
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
              self.openController()
        })
    }
    
    //MARK: -openController
    
    func openController(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "ProductSearch") as! ProductSearchListViewController
        
        let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
        
        self.present(navigationController, animated: true, completion: nil)
            
    }

}

