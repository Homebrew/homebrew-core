class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.11.0.tar.gz"
  sha256 "000b873f239e8c5219ede3fd5836d6346ebea64ea928e2d754cdfc0f2071a874"

  bottle do
    sha256 "c426ae411e48c723c5c6fd6a1bd99a5187337139bd9e4d30cee2cad37d88d254" => :high_sierra
    sha256 "ed86ccc7cb99ee87903b75d6238d388f00d7500cd9b18c806f795e35bc80b762" => :sierra
    sha256 "bcffb2ac04a2c77bfec589a5c2d3d9f6125e41d22b56a11041dd823846ae9437" => :el_capitan
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
