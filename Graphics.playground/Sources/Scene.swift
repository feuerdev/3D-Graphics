public struct Scene {
    let spheres:[Sphere]
    
    public init(spheres:[Sphere]) {
        self.spheres = spheres
    }
}

public struct Sphere {
    var origin:Vector3
    var radius:Float
    
    public init(origin:Vector3, radius:Float) {
        self.origin = origin
        self.radius = radius
    }
}
