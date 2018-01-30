class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.10.0.tar.gz"
  sha256 "2abfca27caf83ed7b17e89a4ababd8d455c9d902ec6440f8a87f63bc124dbaf6"

  bottle do
    sha256 "89057516d118f502a979a0984d513a20de0a863e7d61122c55a098bee94cc201" => :high_sierra
    sha256 "c42abd28eebb9a9bd923fb35df3fdffe209a322f3fae55f3ae1f292039b0de44" => :sierra
    sha256 "c7efcec941a0c0d1299fbd308c1e72fd309b33515f9d0a38467228e107e231b7" => :el_capitan
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
