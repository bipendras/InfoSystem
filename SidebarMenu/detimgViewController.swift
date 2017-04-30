//
//  detimgViewController.swift
//  nBulletin
//
//  Created by beependra on 12/30/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit

class detimgViewController: UIViewController, UIScrollViewDelegate{
    var imageurl = ""
    @IBOutlet weak var scrl: ImageScrollView!
    @IBOutlet weak var defaultView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()



        
    }
    override func viewWillLayoutSubviews(){
       // setZoomScale()
     //   scrollViewDidZoom(defaultView)
    }
    override func viewWillAppear(_ animated: Bool) {
    
        print(imageurl)
        imageView.af_setImage(withURL: URL(string: imageurl)!)
        //loadImageFromUrl(url: imageurl, view: imageView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidZoom(_ scrl: UIScrollView) {
        let offsetX = max((scrl.bounds.width - scrl.contentSize.width) * 0.5, 0)
        let offsetY = max((scrl.bounds.height - scrl.contentSize.height) * 0.5, 0)
        self.scrl.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
        //setZoomScale()
    }
    
    /*//
    func viewForZoomingInScrollView(defaultView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                    //    img = UIImage(<#T##NSData#>data: )
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    

   /*func setZoomScale() {
        
        var minZoom = min(self.view.bounds.size.width / imageView!.bounds.size.width, self.view.bounds.size.height / imageView!.bounds.size.height);
        
        if (minZoom > 0.5) {
            minZoom = 0.5;
        }
        
        //defaultView.minimumZoomScale = minZoom;
        //defaultView.zoomScale = minZoom;
        
    }*/
  /*  func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = defaultView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let minZoomScale = min(widthScale, heightScale)
        defaultView.minimumZoomScale = imageViewSize.width
        defaultView.zoomScale = minZoomScale
    }*/
   /*/
     func scrollViewDidZoom(_ defaultView: UIScrollView) {
        let offsetX = max((defaultView.bounds.width - defaultView.contentSize.width) * 0.5, 0)
        let offsetY = max((defaultView.bounds.height - defaultView.contentSize.height) * 0.5, 0)
        self.defaultView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
        //setZoomScale()
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/
}
