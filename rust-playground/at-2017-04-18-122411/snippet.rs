// -*- mode:rust;mode:rust-playground -*-
// snippet of code @ 2017-04-18 12:24:11

// === Rust Playground ===
// Execute the snippet with Ctl-Return
// Remove the snippet completely with its dir and all files M-x `rust-playground-rm`

fn main() {
    let (tx, rx) = channel();
    spawn(proc () {
        tx.send(2u+2);
        tx.send(3u+5);
    });
    println!("{}, {}", rx.recv(), rx.recv());
}
