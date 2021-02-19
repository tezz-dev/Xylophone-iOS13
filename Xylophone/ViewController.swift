//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var isLightMode = true
    var notes = ["C", "D", "E", "F", "G", "A", "B"]
    var noteColors = [
        UIColor.blue,
        UIColor.red,
        UIColor.green,
        UIColor.brown,
        UIColor.magenta,
        UIColor.orange,
        UIColor.systemTeal,
        UIColor.blue
    ]
    var noteButtons = [UIButton]()
    let mainStackView   = UIStackView()
    let titleLabel = UILabel()
    let lastNoteLabel = UILabel()
    let footNoteLabel = UILabel()
    var contrastModeButton = UIButton()
    var noteSounds: [String: AVAudioPlayer?] = [:]
    var sound: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        createMainStackView(screenWidth, screenHeight)
        
        createNoteButtons(screenWidth, screenHeight)
        
        setTitleLabel(screenWidth, screenHeight)
        
        setFootNoteLabel(screenWidth, screenHeight)
        
        updateContrastModeButton(screenWidth, screenHeight)
        
        setLastNoteLabel(screenWidth, screenHeight)
        
    }
    
    func updateContrastModeButton(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        contrastModeButton.setImage(UIImage(systemName: isLightMode ? "moon.fill" : "sun.max.fill"), for: .normal)
        contrastModeButton.imageView?.tintColor = isLightMode ? .white : .black
        contrastModeButton.backgroundColor = isLightMode ? .black : .white
        contrastModeButton.layer.cornerRadius = screenHeight / 16 * 0.45
        contrastModeButton.clipsToBounds = true
        contrastModeButton.addTarget(self, action: #selector(contrastModeToggled(_:)), for: .touchUpInside)
        
        self.view.addSubview(contrastModeButton)
        setAutoConstraints(someView: contrastModeButton, width: screenHeight / 16, height: screenHeight / 16, xOffset: 0.0, yOffset: screenHeight / 32, xRelative: true, yRelative: true, xLeading: true, yTop: true)
    }
    
    fileprivate func setTitleLabel(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        titleLabel.text = "xyloPhone"
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 10 + 1)
        titleLabel.textAlignment = .right
        self.view.addSubview(titleLabel)
        setAutoConstraints(someView: titleLabel, width: screenWidth, height: screenHeight / 8, xOffset: 0.0, yOffset: 0.0, xRelative: true, yRelative: true, xLeading: true, yTop: true)
    }
    
    fileprivate func setLastNoteLabel(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        lastNoteLabel.text = "Last Note: nil"
        lastNoteLabel.textColor = .darkGray
        lastNoteLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 12 + 1)
        lastNoteLabel.textAlignment = .center
        self.view.addSubview(lastNoteLabel)
        setAutoConstraints(someView: lastNoteLabel, width: screenWidth, height: screenHeight / 8, xOffset: 0.0, yOffset: screenHeight / 12, xRelative: false, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func setFootNoteLabel(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        footNoteLabel.text = "made by tezz-io"
        footNoteLabel.textColor = .darkGray
        footNoteLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 20 + 1)
        footNoteLabel.textAlignment = .center
        self.view.addSubview(footNoteLabel)
        setAutoConstraints(someView: footNoteLabel, width: screenWidth, height: screenHeight / 12, xOffset: 0.0, yOffset: 0.0, xRelative: true, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func createMainStackView(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        mainStackView.axis  = NSLayoutConstraint.Axis.vertical
        mainStackView.distribution  = UIStackView.Distribution.equalSpacing
        mainStackView.alignment = UIStackView.Alignment.center
        mainStackView.spacing   = 16.0
        self.view.addSubview(mainStackView)
        setAutoConstraints(someView: mainStackView, width: screenWidth, height: screenHeight, xOffset: 0.0, yOffset: 0.0, xRelative: false, yRelative: false, xLeading: true, yTop: false)
    }
    
    fileprivate func createNoteButtons(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {
        for i in 0..<notes.count {
            noteButtons.append(createButton(title: notes[i], backgroundColor: noteColors[i]))
            
            self.mainStackView.addSubview(noteButtons[i])
            
            setAutoConstraints(someView: noteButtons[i], width: screenWidth - CGFloat(i) * screenWidth / 24, height: screenHeight / 10, xOffset: 0.0, yOffset: -CGFloat(i+2) * screenHeight / 10 + screenHeight, xRelative: false, yRelative: true, xLeading: true, yTop: false)
            
            noteButtons[i].addTarget(self, action: #selector(noteButtonPressed(_:)), for: .touchUpInside)
        }
    }
    
    func setAutoConstraints(someView: UIView, width: CGFloat, height: CGFloat, xOffset: CGFloat, yOffset: CGFloat, xRelative: Bool, yRelative: Bool, xLeading: Bool, yTop: Bool) {
                
        someView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(
           item: someView,
           attribute: NSLayoutConstraint.Attribute.width,
           relatedBy: NSLayoutConstraint.Relation.equal,
           toItem: nil,
           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
           multiplier: 1,
           constant: width
        )
        let heightConstraint = NSLayoutConstraint(
           item: someView,
           attribute: NSLayoutConstraint.Attribute.height,
           relatedBy: NSLayoutConstraint.Relation.equal,
           toItem: nil,
           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
           multiplier: 1,
           constant: height
        )
        var xConstraint = NSLayoutConstraint(
            item: someView,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
        )
        var yConstraint = NSLayoutConstraint(
            item: someView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1,
            constant: 0
        )
        if xRelative {
            if xLeading {
                xConstraint = NSLayoutConstraint(
                   item: someView,
                   attribute: NSLayoutConstraint.Attribute.leading,
                   relatedBy: NSLayoutConstraint.Relation.equal,
                   toItem: view,
                   attribute: NSLayoutConstraint.Attribute.leadingMargin,
                   multiplier: 1.0,
                   constant: xOffset
                )
            }
            else {
                xConstraint = NSLayoutConstraint(
                   item: someView,
                   attribute: NSLayoutConstraint.Attribute.trailing,
                   relatedBy: NSLayoutConstraint.Relation.equal,
                   toItem: view,
                   attribute: NSLayoutConstraint.Attribute.trailingMargin,
                   multiplier: 1.0,
                   constant: -xOffset
                )
            }
            
        }
        if yRelative {
            if yTop {
                yConstraint = NSLayoutConstraint(
                    item: someView,
                    attribute: NSLayoutConstraint.Attribute.top,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: view,
                    attribute: NSLayoutConstraint.Attribute.topMargin,
                    multiplier: 1.0,
                    constant: yOffset
                )
            }
            else {
                yConstraint = NSLayoutConstraint(
                    item: someView,
                    attribute: NSLayoutConstraint.Attribute.bottom,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: view,
                    attribute: NSLayoutConstraint.Attribute.bottomMargin,
                    multiplier: 1.0,
                    constant: -yOffset
                )
            }
            
        }
        view.addConstraints(
                    [widthConstraint, heightConstraint, xConstraint, yConstraint]
            )
    }
    
    func createButton(title: String, backgroundColor: UIColor) -> UIButton {
            let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
            let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
            
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.backgroundColor = backgroundColor
            button.titleLabel!.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 10 - 5)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = screenHeight / 9 * 0.45
            button.clipsToBounds = true
            button.layer.borderWidth = 4
            button.layer.borderColor = UIColor.white.cgColor
            return button
        }
    
    @objc func contrastModeToggled(_ sender: UIButton) {
        self.isLightMode.toggle()
        overrideUserInterfaceStyle = isLightMode ? .light : .dark
        self.view.backgroundColor = isLightMode ? .white : .black
        
        titleLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        lastNoteLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        footNoteLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        contrastModeButton.setImage(UIImage(systemName: isLightMode ? "moon.fill" : "sun.max.fill"), for: .normal)
        contrastModeButton.imageView?.tintColor = isLightMode ? .white : .black
        contrastModeButton.backgroundColor = isLightMode ? .black : .white
        
        for button in noteButtons {
            button.setTitleColor(isLightMode ? .white : .black, for: .normal)
            button.layer.borderColor = isLightMode ? UIColor.white.cgColor : UIColor.black.cgColor
        }
    }
    
    @objc func noteButtonPressed(_ sender: UIButton) {
        let note = sender.titleLabel?.text!
        let path = Bundle.main.path(forResource: "\(note ?? "C").wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            sound = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Error")
        }
        sound?.play()
        lastNoteLabel.text = "Last Note: \(sender.titleLabel?.text ?? "nil")"
    }

}

