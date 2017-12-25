// -*- mode:rust;mode:rust-playground -*-
// snippet of code @ 2017-04-18 11:36:23

// === Rust Playground ===
// Execute the snippet with Ctl-Return
// Remove the snippet completely with its dir and all files M-x `rust-playground-rm`

struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        let a = &self.x;
        a
    }
}

fn main() {
    let p = Point{x:5, y:10};
    println!("p.x = {}", p.x())
}
