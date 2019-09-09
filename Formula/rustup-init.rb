class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.19.0.tar.gz"
  sha256 "b5b2c1c369e44f0c6529169f0c4e680c257a13d220b643a31686033fff2a5983"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9e405380444bb5afc9edd9f0938558c9acaa0f15c8a01d88f85834801e59100" => :mojave
    sha256 "8e302783ad37e7f272161b9ae7e6f45dd4e86eb1267fa0d29c873e4fe0c039d0" => :high_sierra
    sha256 "c26c7c239ce0db72e2e079165e811a5065fa4f6448eac61d6147c6b3e46a6f8e" => :sierra
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
