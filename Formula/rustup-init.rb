class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.7.0.tar.gz"
  sha256 "8ee4602ca471594e879b9c74b65261355d055f815406854ba330129eab9a034f"

  bottle do
    sha256 "8b488da61fbc377aca3150d228f798b1d6972e54f428165a32570a2cdabd5c3a" => :high_sierra
    sha256 "4c34084b06646567d4b0aee5ef2a7c7f9156e4252e8c5df5bdac599b6eeb60ba" => :sierra
    sha256 "685ca19ad3f60700ba03adfd3de2758c6f59a0dd052fa594b1ee756486932fa9" => :el_capitan
    sha256 "4592f2c264527e4fc59f6fa40f5beed620f29e2b7543c54c18f5cb83a5dc6160" => :yosemite
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
