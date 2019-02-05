//
//  SwipingPhotosController.swift
//  Tinsho
//
//  Created by Sherif Kamal on 2/2/19.
//  Copyright © 2019 Sherif Kamal. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers = [UIViewController]()
    fileprivate var barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate var deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let isCardViewMode: Bool
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            setupBarViews()
        }
    }
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        view.backgroundColor = .white
        if isCardViewMode {
            disableSwipingability()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let currentController = viewControllers?.first!
        if let index = controllers.firstIndex(of: currentController!) {
            barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = deselectedBarColor })
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let prevIndex = max(index - 1, 0)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .reverse, animated: false)
                barsStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
        }
    }
    
    fileprivate func disableSwipingability() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    fileprivate func setupBarViews() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 4
            barsStackView.addArrangedSubview(barView)
        }
        var topPadding: CGFloat = 8
        
        if !isCardViewMode {
            topPadding += UIApplication.shared.statusBarFrame.height
        }
        view.addSubview(barsStackView)
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 4
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: topPadding, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: { $0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == currentViewController }) {
            barsStackView.arrangedSubviews.forEach({ $0.backgroundColor = deselectedBarColor })
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "like_circle"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
        imageView.clipsToBounds = true
    }
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
