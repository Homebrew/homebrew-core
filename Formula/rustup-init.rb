class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"
  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.14.0.tar.gz"
  sha256 "ab125d9b12bf0f3f7e7ad98e826035fa1ae3dbe6ba8b78be4c82f9cde00bc59f"
  revision 1

  bottle do
    sha256 "cadc99f1b8a28147e3311e362d6b2a757c4bbf76c5110e8c01157bd4216895a4" => :mojave
    sha256 "6be0727b59e12fea77c07a25c9ca47e764bdee23b20a935ca86a43b55613834c" => :high_sierra
    sha256 "56e5dc187f371b3c28283b7a27ede47916cd77b6a3de3a1b0ab174ee324410d5" => :sierra
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
