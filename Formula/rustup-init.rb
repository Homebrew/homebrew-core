class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.5.0.tar.gz"
  sha256 "77771f75af0b4212d8144371390be9fe469d3f47251db009e843733c601df6c3"

  bottle do
    sha256 "5993d8463639960825110af68dc87ebb4831d3bd378a1ce03f4f3b2af24e3340" => :sierra
    sha256 "856932cfdc8d610ebdec649810fd000e01eda6f7a730340a78b9effe6303bd92" => :el_capitan
    sha256 "ad435f8ce2421ff946d8f124cd601b23864da418e7db9bf00b52fd39766388a5" => :yosemite
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
