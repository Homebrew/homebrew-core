class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.10.0.tar.gz"
  sha256 "2abfca27caf83ed7b17e89a4ababd8d455c9d902ec6440f8a87f63bc124dbaf6"

  bottle do
    sha256 "3b559275c845bd6933ac017d845d3c6bed76bd6539374e1f24ac6fddef659d78" => :high_sierra
    sha256 "6f87b44743e96122ffd8852e6a1650aed706b192356a8aa3162feee463dd09b9" => :sierra
    sha256 "30db9d2ec44e9c9884820720f4f402f29ebd8c27dd09f4370484b908eec99d7a" => :el_capitan
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
