/// I'm putting everything that requires computation in this file for improved Playground performance
import CoreGraphics

public class Raytracer {
    
    let width:Int
    let height:Int
    let scene:Scene
    let background:UInt32
    var pixels: [UInt32]
    
    /// Constructor
    /// - Parameters:
    ///   - width: width of Canvas
    ///   - height: height of Canvas
    ///   - background: default pixel background color
    public init(width:Int, height:Int, scene:Scene, background:UInt32 = 0xff000000) {
        self.width = width
        self.height = height
        self.scene = scene
        self.background = background
        self.pixels = [UInt32](repeating: background, count: width*height)
    }
    
    /// Render the scene
    /// - Returns: Image or nil
    public func draw() -> CGImage? {
        fillBuffer()
        return createContext()?.makeImage()
    }
    
    /// Base API to set a pixel to a color. Converts from cartesian system (origin in center) to graphics system (origin top left)
    /// - Parameters:
    ///   - x: Cartesian X coordinate
    ///   - y: Cartesian Y coordinate
    ///   - color: Color of pixel
    private func putPixel(_ x:Int, _ y:Int, _ color: UInt32) {
        let sX = (width/2)+x
        let sY = (height/2)-y-1
        let index = (width*sY)+(sX)
        pixels[index] = color
    }
    
    /// Main work function iterates through each pixel on the canvas and calculates its pixel
    private func fillBuffer() {
        let from = Vector3(x:0, y:0, z:0)
        for x in -width/2..<width/2 {
            for y in -height/2..<height/2 {
                let to = canvasToViewport(x,y)
                let color = traceRay(from, to, tMin:1, tMax:MAXFLOAT)
                putPixel(x,y,color)
            }
        }
    }
    
    /// Calculates the viewport coordinate for a given canvas pixel
    /// - Parameters:
    ///   - x: Cartesian X coordinate
    ///   - y: Cartesian Y coordinate
    /// - Returns: Vector3 of given pixel on the viewport
    private func canvasToViewport(_ x:Int, _ y:Int) -> Vector3 {
        return Vector3(x: Float(x)*1/Float(width), y: Float(y)*1/Float(height), z: 1.0)
    }
    
    /// Calculates the target color of a given ray
    /// - Parameters:
    ///   - from: Vector3 of camera origin
    ///   - to: Vector3 of viewport coordinate
    ///   - tMin: Position on ray to start tracing
    ///   - tMax: Position on ray to end tracing
    /// - Returns: UInt32 of target color
    private func traceRay(_ from:Vector3, _ to:Vector3, tMin:Float, tMax:Float) -> UInt32 {
        return 0xFF0000FF
    }
    
    /// Sets up the rendering context using CoreGraphics
    /// - Returns: CGContext or nil
    private func createContext() -> CGContext? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue |
                         CGImageAlphaInfo.premultipliedLast.rawValue &
                         CGBitmapInfo.alphaInfoMask.rawValue
        
        var mutatablePixels = pixels
        
        let mutatablePointer = UnsafeMutableRawBufferPointer(start: &mutatablePixels, count: pixels.count).baseAddress
        
        let height = pixels.count / width
        let bytesPerRow = width * 4
        
        let context = CGContext(data: mutatablePointer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        return context
    }
}
