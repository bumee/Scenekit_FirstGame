import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    @Binding var test: Bool
//    @Binding var sceneView: SCNView?
    var sceneView: SCNView? = SCNView()
    var scene: SCNScene? = SCNScene(named: "art.scnassets/ship.scn")
    
    func makeUIView(context: Context) -> SCNView {
        sceneView?.allowsCameraControl = true
        sceneView?.autoenablesDefaultLighting = true
        sceneView?.scene = scene
        return sceneView!
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        if test {
            rotate()
            test.toggle()
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
    
    var body: some View {
        
        VStack {
            SceneKitView(test: $test1)
                .frame(width: 300, height: 300)
            
            Button("rotate"){
                test1 = true
                print(test1)
            }
           
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
