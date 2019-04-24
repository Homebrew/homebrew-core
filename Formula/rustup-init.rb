class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.18.0.tar.gz"
  sha256 "d0a3c832d866a9408e272e0b54748dcb1261d7b0669d44b69efca7542e0677f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "04d0ddebac1544b99f8eebe9ad4357b76877154ce157bb0badd79f9e9eca66bb" => :mojave
    sha256 "7d75a5bff539711ed359c21b752a446d04fc098711205d947744c92a065a56e4" => :high_sierra
    sha256 "34ac177dbdfd66b190d84acf81db5047fa69c505649288c62bbdceb355b8d16e" => :sierra
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--root", prefix, "--path", ".",
                    "--features", "no-self-update"
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
