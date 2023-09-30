package main

import "core:fmt"
import "core:math"

I : int : 100;
G : f64 : 1;
dt: f64 : 0.002;

Vector2 :: struct {
    x : f64,
    y : f64,
};

Body :: struct {
    mass         : f64,
    position     : Vector2,
    velocity     : Vector2,
    acceleration : Vector2,
};

new_body :: proc(x, y, vx, vy, ax, ay, m: f64) -> Body {
    return Body{
        m,
        Vector2{x, y},
        Vector2{vx, vy},
        Vector2{ax, ay}
    };
}

bodies := [?]Body { new_body(0, 0, 0, 0, 0, 0, 1000),
                    new_body(1, 1, 10, 0, 0, 0, 50) };

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

gravitational_force_vector :: proc(a, b: Body, unit: Vector2, dist: f64) -> Vector2 {
    magnitude := G * (a.mass * b.mass) / (dist * dist);
    force     := Vector2{magnitude * unit.x,
                         magnitude * unit.y};

    return force;
}

calculate_acceleration :: proc(a: Body) -> Vector2 {
    acceleration := Vector2{0.0, 0.0};

    for body in bodies {
        if body == a {
            continue;
        }

        dist := distance(a, body);
        unit := Vector2{(body.position.x - a.position.x) / dist,
                        (body.position.x - a.position.x) / dist }

        force := gravitational_force_vector(a, body, unit, dist);

        acceleration.x += force.x * unit.x;
        acceleration.y += force.y * unit.y;
    }

    return acceleration;
}

update_body :: proc(a: Body) -> Body {
    a := a;

    k1v := Vector2{dt * a.acceleration.x, dt * a.acceleration.y};
    k1r := Vector2{dt * a.velocity.x, dt * a.velocity.y};

    acceleration := calculate_acceleration(a);

    k2v := Vector2{dt * acceleration.x, dt * acceleration.y};
    k2r := Vector2{dt * (a.velocity.x + 0.5 * k1v.x), dt * (a.velocity.y + 0.5 * k1v.y)};

    k3v := Vector2{dt * acceleration.x, dt * acceleration.y};
    k3r := Vector2{dt * (a.velocity.x + 0.5 * k2v.x), dt * (a.velocity.y + 0.5 * k2v.y)};

    k4v := Vector2{dt * acceleration.x, dt * acceleration.y};
    k4r := Vector2{dt * (a.velocity.x + k3v.x), dt * (a.velocity.y + k3v.y)};

    a.position.x += (k1r.x + 2 * k2r.x + 2 * k3r.x + k4r.x) / 6;
    a.position.y += (k1r.y + 2 * k2r.y + 2 * k3r.y + k4r.y) / 6;

    a.velocity.x += (k1v.x + 2 * k2v.x + 2 * k3v.x + k4v.x) / 6;
    a.velocity.y += (k1v.y + 2 * k2v.y + 2 * k3v.y + k4v.y) / 6;

    a.acceleration = acceleration;

    return a;
}

main :: proc() {
    for i in 0..=I {
        for _, a in bodies {
            bodies[a] = update_body(bodies[a]);
            fmt.println("(", bodies[a].position.x, ",", bodies[a].position.y, ")");
        }
        fmt.println("----")
    }
}

