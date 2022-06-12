//
//  ImageViewController.swift
//  FileManager
//
//  Created by Alex on 12.06.22.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var manager = ElementsManager()
    
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpScrollView()
        
        setImage(imageURL)
    }
    
    private func setUpScrollView() {
        scrollView.delegate = self
    }
    
    func setImage(_ url: URL) {
        guard let data = try? Data(contentsOf: imageURL) else {
            return
        }
        self.imageView.image = UIImage(data: data)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print(scale)
    }
}
