class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.23.1.tar.gz"
  sha256 "0203231bfe405ee1c7d5e7e1c013b9b8a2dc87fbd8474e77f500331d8c26365f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa448a74f8b43d8ae9c5efaca38dcdc2a52424d08997efc84b2687578edb94f8" => :big_sur
    sha256 "38058277d2a6f4c96b6162a17423cb24efcffe60ca8f6a7eb714d0063526e9e7" => :catalina
    sha256 "7f5ce27fbe561ab4536dd0414918ae66c8adf67fbf49f8d36ce757ea296ff3a5" => :mojave
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
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
