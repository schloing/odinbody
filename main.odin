package main

import "core:fmt"
import "core:mem"
import "core:math"

G : f64 : 1;
dt: f32 : 0.2;

Vector2 :: struct {
    x : f64,
    y : f64,
};

Body :: struct {
    mass         : f64,
    position     : Vector2,
    acceleration : Vector2,
};

distance :: proc(a, b: Body) -> f64 {
    dx := math.pow(a.position.x - b.position.x, 2);
    dy := math.pow(a.position.y - b.position.y, 2);

    return math.sqrt(dx + dy);
}

gravitational_force_scalar :: proc(a, b: Body) -> f64 {
    dist  := distance(a, b);
    force := G * (a.mass * b.mass) / (dist * dist);
   
    return force;
}

update_body :: proc(a: Body) {
    acceleration := Vector2{};
    // foreach other object...
    
    k1v := Vector2{dt * acceleration.x, dt * acceleration.y};
    k1r := Vector2{dt * object.velocity.x, dt * object.velocity.y};
}

main :: proc() {
}
