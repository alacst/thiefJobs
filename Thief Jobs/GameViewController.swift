import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sKView = self.view as! SKView
        sKView.showsFPS = true
        sKView.showsNodeCount = true
        sKView.showsPhysics = true
        
        sKView.ignoresSiblingOrder = false
        
        let scene = GameScene(size: sKView.bounds.size)
        
        scene.scaleMode = .aspectFill
        
        sKView.presentScene(scene)
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
