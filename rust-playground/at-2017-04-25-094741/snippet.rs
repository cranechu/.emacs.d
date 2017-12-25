// -*- mode:rust;mode:rust-playground -*-
// snippet of code @ 2017-04-25 09:47:41

// === Rust Playground ===
// Execute the snippet with Ctl-Return
// Remove the snippet completely with its dir and all files M-x `rust-playground-rm`

use std::sync::Arc;

fn main() {
    let x = Arc::new(5);
    let y = x.clone();

    println!("Results: {:?}", y);
}
