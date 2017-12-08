class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"

  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.7.0.tar.gz"
  sha256 "8ee4602ca471594e879b9c74b65261355d055f815406854ba330129eab9a034f"

  bottle do
    sha256 "c1080fc6210079c12244bec4e1eedc57efd13f512342d88fd6a551701490838b" => :high_sierra
    sha256 "96ba7b5243bba8b996496c91e8d096a54af0755475289f18a63770e2d6a012b5" => :sierra
    sha256 "f0c1efda6af388181657745915106cabcf41359c64ec23a468634bfeeb16546f" => :el_capitan
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
