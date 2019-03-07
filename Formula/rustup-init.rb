class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.17.0.tar.gz"
  sha256 "6db73f9684b4d93de47cd511ebd56c2821c37bb41054a4a60060b496764f1f4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f31fea6610b20aeace8c1462c838a1edff41bb5fb4442b0259a8fc68cd8bafbc" => :mojave
    sha256 "f8f40d63b06b58e8f8a138e957e3e1c9e567518278e53c9fa03bea3f428b79ac" => :high_sierra
    sha256 "f7bb37881a60eab7b7f001db2fc82784b43ce9fb5d061b9465b5b1d502fb67b4" => :sierra
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
