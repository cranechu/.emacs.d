// -*- mode:rust;mode:rust-playground -*-
// snippet of code @ 2017-04-25 15:04:46

// === Rust Playground ===
// Execute the snippet with Ctl-Return
// Remove the snippet completely with its dir and all files M-x `rust-playground-rm`

enum Message {
    Move { x: i32, y: i32},
    Write(String),
}

fn main() {
    let v = vec!["Hello".to_string(), "World".to_string()];
    let vl: Vec<Message> = v.into_iter().map(Message::Write).collect();
    println!("{:?}", vl[0]);
}
