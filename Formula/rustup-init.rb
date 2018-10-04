class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"
  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.14.0.tar.gz"
  sha256 "ab125d9b12bf0f3f7e7ad98e826035fa1ae3dbe6ba8b78be4c82f9cde00bc59f"
  revision 1

  bottle do
    sha256 "11ccb4a96d2927f6509534e699cc9302e1fba469162fe6c8a236cf54b1d0064c" => :mojave
    sha256 "ffdd7ba2f76fce891b3d1bdaf405b864167f0b1a330caa81185477c22006d93b" => :high_sierra
    sha256 "9979dbb7591a8b90ce5b49ababc02159d5ec423a76b282b03eaa6f7fa05eb7be" => :sierra
    sha256 "871a6357e0c95aaa4e293ed1daf609397339a7035dc83a51b10597c72b1380ef" => :el_capitan
  end

  depends_on "rust" => :build

  # Fixes `rustup-init` not working when it is relative symlink.
  # https://github.com/rust-lang-nursery/rustup.rs/issues/1512
  # https://github.com/rust-lang-nursery/rustup.rs/pull/1521
  patch do
    url "https://github.com/rust-lang-nursery/rustup.rs/pull/1521/commits/ebbfced7ee4aeb5be4c775f8f85e351093d5818f.diff?full_index=1"
    sha256 "34dc006d75d747b99dd9fe49bdde396a8bf5443d1e3df1a47c4776c06ec3f3c7"
  end

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
