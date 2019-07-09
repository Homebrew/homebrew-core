class Rustfmt < Formula
  desc "Rust code formatter"
  homepage "https://github.com/rust-lang/rustfmt"
  url "https://github.com/rust-lang/rustfmt/archive/v1.3.2.tar.gz"
  sha256 "d9ff195fa0f02012c0be8aa7b387e2140271809f61f3b621d7228a338670e040"

  depends_on "rustup-init" => :build

  depends_on "rust"

  def install
    ENV["RUSTUP_HOME"] = buildpath/"rustup"
    ENV["CARGO_HOME"] = buildpath/"cargo"
    system "rustup-init", "--default-toolchain", "nightly", "-y"
    system buildpath/"cargo/bin/cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"Cargo.toml").write <<~EOS
      [package]
      name = "hello"
      version = "0.1.0"
      authors = ["homebrew"]

      [dependencies]
    EOS
    (testpath/"src/main.rs").write <<~EOS
      println!  ( "hello, world" )  ;
    EOS
    system "cargo", "fmt"
    assert_match 'println!("hello, world");', (testpath/"src/main.rs").read
  end
end
