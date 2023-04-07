import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    @Binding var isRotate: Bool
    @Binding var isMoving: Bool
//    @Binding var sceneView: SCNView?
    var sceneView: SCNView? = SCNView()
    var scene: SCNScene? = SCNScene(named: "art.scnassets/machine.scn")
    
    var cameraNode: SCNNode? {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        return cameraNode
    }
    
    func makeUIView(context: Context) -> SCNView {
        sceneView?.allowsCameraControl = true
        sceneView?.autoenablesDefaultLighting = true
        sceneView?.scene = scene
        sceneView?.pointOfView = cameraNode
        return sceneView!
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        if isRotate {
            rotate()
            isRotate.toggle()
        }
        if isMoving {
            movingForeverToZ()
            isMoving.toggle()
        }
    }
    
    func movingForeverToZ() {
        let scene = self.sceneView?.scene
        let box = scene!.rootNode.childNodes
        for target in box {
            target.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: 10, duration: 10.0)))
        }
    }
    
    func rotate (){
        let scene = self.sceneView?.scene
        let box = scene!.rootNode.childNodes
        let action = SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 1)
        for target in box {
            target.runAction(action)
        }
    }
}

struct ContentView: View {
    
//    @State var t = SceneKitView(sceneView: Binding<SCNView?>)
    @State private var test1: Bool = false
    @State private var isMoving1: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                SceneKitView(isRotate: $test1, isMoving: $isMoving1)
                    .ignoresSafeArea(.all)
               
            }
            VStack{
                Button("rotate"){
                    test1 = true
                    print(test1)
                }
                .position(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/1.2)
                
                Button("moving"){
                    isMoving1 = true
                    print(isMoving1)
                }
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
