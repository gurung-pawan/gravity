# N-Body Gravity Simulator

A real-time gravitational n-body simulation built in **Godot 4**, featuring physically-based gravity, body collisions, a dynamic camera system, and a UI, all running at interactive framerates.

---

![Banner screenshot of the simulation running](./images/banner.gif)

*Caption: Binary System*

---

## Features

- **Velocity Verlet Integrator** - robust integrator for stable orbits
- **Collision detection** - bodies merge or fragment when they collide
- **Star shader** - visually distinct rendering for stellar bodies
- **Camera System with Practically Infinite Space** - can zoom in and out into large distances with empty space in all directions
- **Clean architecture** - physics, simulation logic, and rendering are fully separated

---

## Getting Started

### Requirements

- [Godot 4.x](https://godotengine.org/download) (tested on 4.2+)
- No extra plugins required

### Running the simulation

1. Clone or download this repository
2. Open **Godot 4** and choose **Import Project**
3. Point it at the project folder and open it
4. Press **F5** (or the ▶ Play button) to run

##  How It Works

### Physics pipeline (per frame)

```
Sim.gd  →  Physics.gd  →  Gravity.gd   (compute forces on all pairs)
                       →  Collision.gd  (detect and resolve overlaps)
        →  body.gd         (apply velocity, update positions)
```

1. **Gravity** - `Gravity.gd` iterates every unique body pair, computes the Newtonian attractive force, and accumulates acceleration vectors. A softening factor ε prevents numerical singularities at very small distances.

2. **Collision** - `Collision.gd` checks all pairs for sphere overlap. In `MERGE` mode the smaller body is absorbed into the larger (masses and momentum are conserved). In `FRAGMENTATION` bodies blow into multiple parts.

3. **Integration** - each `body.gd` node applies its accumulated acceleration to its velocity and steps its position forward (Velocity Verlet).

## Current Progress

- **C++ integration for better performance**
- **More custom body types**
- **Barnes Hut algorithm for O(nlogn)**

---

## License

MIT - do whatever you like with it, attribution appreciated.