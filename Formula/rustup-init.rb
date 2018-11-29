class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"
  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.15.0.tar.gz"
  sha256 "470441d59dbb33f4e3e52e3f7420734dae0066598802c2b3b4f89f5b3a6a9e45"

  bottle do
    sha256 "7c64015c8bca7660a92879073984fc5bdd8de896588c6ca6a15b15fdcce3c345" => :mojave
    sha256 "26485e684c66e884606473d9f8f2c0575c3494028663d3a14d53912748760deb" => :high_sierra
    sha256 "f79c6f3c1ce8c5faf028ca2ba67d70d9e12d5d5fac582fa30aaaaecca80a4fab" => :sierra
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
