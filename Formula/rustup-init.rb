class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.20.0.tar.gz"
  sha256 "f58381eb940353a7c78ec6c0f857d94175e207237437db369d6f0ada9c12e42a"

  bottle do
    cellar :any_skip_relocation
    sha256 "031768f5038a938da162c65c1b361762b4ebb4ed48f2f45a81aef09db5b64004" => :catalina
    sha256 "6321dcd0c856fba4a74454ed0226084d99dd58d731f98f01720f497aee25b1a6" => :mojave
    sha256 "da5882848bf593e7ddda3a80033598dd2fe62edeba0b5be17cf4df4e57aa48e8" => :high_sierra
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
