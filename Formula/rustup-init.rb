class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.9.0.tar.gz"
  sha256 "24a6ed09553c8ec6d1c683eed0d34f40af779ae8439e7f7e821eec9ea4e5fdb6"

  bottle do
    sha256 "0e5d94d5a541557c7b62ca5c6165eb1bf176e4d0e4e0f6c53dee6d576f1529a6" => :high_sierra
    sha256 "c57de8c06eaba43d4db765a1a8d39a36b6345ef34c3f3e34a7584091a09c1049" => :sierra
    sha256 "d58bfe6505d754c48aa3577384f4a6d2fc1d3f7065a1cc03a2feee2f8d6e1f3c" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "build", "--release", "--verbose"

    bin.install buildpath/"target/release/rustup-init"
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
