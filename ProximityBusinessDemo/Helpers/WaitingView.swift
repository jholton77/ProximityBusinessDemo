//
//  WaitingView.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/2/21.
//


import Foundation
import SwiftyGif

extension UIViewController {
    func startWaitingView(title : String) {
       
            for subView in self.view.subviews {
                if subView.isKind(of: WaitingView.self) {
                    //(subView as! WaitingView).waitingAnimationView!.logoGifImageView.stopAnimatingGif()
                    subView.removeFromSuperview()
                }
            }
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
       
            let waitingView = WaitingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), title: title)
            
            self.view.addSubview(waitingView)

            waitingView.waitingAnimationView!.logoGifImageView.delegate = self
        
            waitingView.waitingAnimationView!.logoGifImageView.startAnimatingGif()
       
        /*
        var count = 0
        var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ t in
            count += 1
            print(count)
            if count >= 5 {
                t.invalidate()
            }
        }
        */
    }
    
    func stopWaitingView() {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for subView in self.view.subviews {
                if subView.isKind(of: WaitingView.self) {
                    subView.removeFromSuperview()
                }
            }
        //}
    }
    
    func stopWaitingViewWithFadeout() {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for subView in self.view.subviews {
                if subView.isKind(of: WaitingView.self) {
                    //(subView as! WaitingView).waitingAnimationView!.logoGifImageView.stopAnimatingGif()
                    //sleep(1)
                    UIView.animate(withDuration: 0.4, animations: {
                        subView.alpha = 0
                    }, completion: {(finished) in
                        subView.removeFromSuperview()
                    })
                }
            }
        //}
    }
    
    func isWaitingViewAlreadyShowing() -> Bool {
        for subView in self.view.subviews {
            if subView.isKind(of: WaitingView.self) {
                return true
            }
        }
       
        return false
    }
}

class WaitingView: UIView {

    var waitingAnimationView :WaitingAnimationView?
    var viewTransparent : UIView?
    var viewSquare : UIView?
    var labelTitle : UILabel?
    
    required init(frame: CGRect, title: String){
        super.init(frame: frame)
        commonInit(title: title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }

    func commonInit(title : String) {
        self.backgroundColor = .clear//.darkGray
        self.alpha = 1
        
        viewTransparent = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        viewTransparent?.backgroundColor = .lightGray
        viewTransparent?.alpha = 0.8
        
        self.addSubview(viewTransparent!)
        
        let x = self.frame.width / 2 - 50
        let y = self.frame.height / 2 - 50
        
        viewSquare = UIView(frame: CGRect(x: x, y: y, width: 100, height: 100))
        viewSquare?.backgroundColor = .white
        viewSquare?.alpha = 1
        viewSquare?.layer.cornerRadius = 10
        
        self.addSubview(viewSquare!)
        
        labelTitle = UILabel(frame: CGRect(x: 0, y: 10, width: 100, height: 15))
        labelTitle?.textAlignment = .center
        labelTitle?.font = UIFont(name: "SF Pro Text Regular", size: 10)
        labelTitle?.font = labelTitle!.font.withSize(12)
        labelTitle?.textColor = .black
        labelTitle?.adjustsFontSizeToFitWidth = false
        labelTitle?.text = title
        
        viewSquare?.addSubview(labelTitle!)
        
        waitingAnimationView = WaitingAnimationView(frame: CGRect(x: 0, y: 33, width: 100 , height: 56.625))
        viewSquare?.addSubview(waitingAnimationView!)

        //waitingAnimationView!.logoGifImageView.startAnimatingGif()
    }
    
    func stop() {
        
    }
}

class WaitingAnimationView: UIView {
    
    var width : CGFloat = 0
    var height : CGFloat = 0
    var logoGifImageView = UIImageView()
    //let logoGifImageView = UIImageView(gifImage: UIImage(gifName: "proximity_logo_reveal_with_type.gif"), loopCount: 1)

    override init(frame: CGRect) {
        //var testFrame = CGRect(x: 0, y: 0, width: width , height: height)
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        
        self.backgroundColor = .clear
        do
        {
            //logoGifImageView = UIImageView(gifImage: try UIImage(gifName: "loading-loop.gif"), loopCount: 100)
            //logoGifImageView = UIImageView(gifImage: try UIImage(gifName: "logo-notitle-fade-looping.gif"), loopCount: 100)
            /*
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
            print(formatter.string(from: NSDate() as Date) + " --> start ")
            */
            //logoGifImageView = UIImageView(gifImage: try UIImage(gifName: "logo-waiting-loop.gif"), loopCount: 200)
            logoGifImageView = UIImageView(gifImage: try UIImage(gifName: "loading-loop.gif"), loopCount: 200)
            /*
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
            print(formatter.string(from: NSDate() as Date) + " --> loaded")
            */
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        logoGifImageView.backgroundColor = .clear
        
        //backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
    
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
    }
}

extension UIViewController: SwiftyGifDelegate {
    public func gifDidStop(sender: UIImageView) {
        
        /*
        if self.isKind(of: WalkthroughFirstTimeUserVC.self) {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"AnimateLastGif"), object: nil)
        }
        else {
            self.stopWaitingView()
        }*/
        
    }
}

