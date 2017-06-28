class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.5.0.tar.gz"
  sha256 "77771f75af0b4212d8144371390be9fe469d3f47251db009e843733c601df6c3"

  bottle do
    sha256 "4aea59d5617cf25c4399dcde2be3a357e03d04d3c4ccbfa3851e42c03dec58bd" => :sierra
    sha256 "75b90ad4afa37676872d76ffa75f974f4049e7dfa1fb0b25052ba1efab07def4" => :el_capitan
    sha256 "e40b42bfc22acf4a01eaa158e884b1d549ee8932b0e3d37876db89af10c62021" => :yosemite
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
    (testpath/"hello.rs").write <<-EOS.undent
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
