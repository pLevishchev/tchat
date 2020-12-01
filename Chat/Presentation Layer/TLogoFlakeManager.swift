import UIKit

/// Manages the life cycle of the slow flake animation
class TLogoFlakeManager {
    
    fileprivate let snowLayer = CAEmitterLayer()
    fileprivate lazy var snowCell: CAEmitterCell = {
        let snowCell = CAEmitterCell()
        snowCell.contents = UIImage(named: "logo")?.cgImage
        snowCell.scale = 0.0002
        snowCell.scaleRange = 0.3
        snowCell.emissionRange = .pi
        snowCell.lifetime = 20.0
        snowCell.birthRate = 10
        snowCell.velocity = -30
        snowCell.velocityRange = -20
        snowCell.yAcceleration = 30
        snowCell.xAcceleration = 5
        snowCell.spin = -0.5
        snowCell.spinRange = 1.0
        return snowCell
    }()
    
    /// Injects snow layer into view hierarchy
    ///
    /// - Parameter view: UIView to insert snow layer within
    func injectSnowLayer(into view: UIView) {
        snowLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
        snowLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowLayer.emitterShape = CAEmitterLayerEmitterShape.line
        snowLayer.beginTime = CACurrentMediaTime()
        snowLayer.timeOffset = CFTimeInterval(2)
        snowLayer.emitterCells = [snowCell]
        
        view.layer.addSublayer(snowLayer)
    }
    
    /// Removes snow flake animation
    func removeFlake() {
        snowLayer.removeFromSuperlayer()
    }
}
