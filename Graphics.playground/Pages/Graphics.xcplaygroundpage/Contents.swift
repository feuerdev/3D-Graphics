let scene = Scene(spheres: [Sphere(origin:Vector3(x: 0, y: 0, z: 0), radius: 1)])
let raytracer = Raytracer(width: 540, height: 480, scene: scene)
raytracer.draw()






