//
//  UINavigationController+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/28/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension UINavigationController {
	
//	func setNavBarVisible(_ animated: Bool = false) {
//		navigationBar.setupForQuanta(bgColor: .white)
//		setNavigationBarHidden(false, animated: animated)
//	}

    func fadeTo_Push(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
		transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }

    func fadeTo_Present(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
		transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        present(viewController, animated: false, completion: nil)
    }

}
