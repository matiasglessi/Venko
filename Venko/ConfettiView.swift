//
//  ConfettiView.swift
//  Venko
//
//  Created by Matias Glessi on 11/04/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public class ConfettiView: UIView {

    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    private var active :Bool!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
            UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
            UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
            UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
            UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        intensity = 0.5
        active = false
    }

    public func start() {
        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)

        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(generateConfettiCell(for: color))
        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }

    public func stop() {
        emitter?.birthRate = 0
        active = false
    }

    func confettiImage() -> UIImage? {

        guard let imagePath = Bundle.main.path(forResource: "confetti", ofType: "png") else {
            return nil
        }
        let url = URL(fileURLWithPath: imagePath)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
        }
        return nil
    }

    func generateConfettiCell(for color: UIColor) -> CAEmitterCell {
        let confettiCell = CAEmitterCell()
        confettiCell.birthRate = 6.0 * intensity
        confettiCell.lifetime = 14.0 * intensity
        confettiCell.lifetimeRange = 0
        confettiCell.color = color.cgColor
        confettiCell.velocity = CGFloat(350.0 * intensity)
        confettiCell.velocityRange = CGFloat(80.0 * intensity)
        confettiCell.emissionLongitude = CGFloat(Double.pi)
        confettiCell.emissionRange = CGFloat(Double.pi)
        confettiCell.spin = CGFloat(3.5 * intensity)
        confettiCell.spinRange = CGFloat(4.0 * intensity)
        confettiCell.scaleRange = CGFloat(intensity)
        confettiCell.scaleSpeed = CGFloat(-0.1 * intensity)
        confettiCell.contents = confettiImage()?.cgImage
        return confettiCell
    }

    public func isActive() -> Bool {
            return self.active
    }
}
