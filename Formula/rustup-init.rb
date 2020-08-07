class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.22.1.tar.gz"
  sha256 "ad46cc624f318a9493aa62fc9612a450564fe20ba93c689e0ad856bff3c64c5b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "12bef1ce5ee98d022eee88019044b30d1c9919fd6f4b14e9ef876f8944e39a96" => :catalina
    sha256 "a4f477ccd1472f43321452297aa935347fd8e12f96d7bd839239e669dd361000" => :mojave
    sha256 "6a4ba7267ffa430c98cc4cf58026473ce07a47a97dcc40acd4031d8d82c209a5" => :high_sierra
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
