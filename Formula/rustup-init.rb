class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.18.2.tar.gz"
  sha256 "03b82d66d1d2529f9b6ff052b40d8f5381336a7ada52a56dd1eb2a6a0c5b6905"

  bottle do
    cellar :any_skip_relocation
    sha256 "e928bea2e142941f723a2e72f17941644709ff0336a629e94ac08a81b62a34a3" => :mojave
    sha256 "994c6e01d9c5bef9fc300da68c1282826d0b78480440940bc9b7d98b0ad1fb65" => :high_sierra
    sha256 "416d3b38a72e433ce18516de3d48bebce20794f183938b3957ba12b7bfb9901a" => :sierra
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
