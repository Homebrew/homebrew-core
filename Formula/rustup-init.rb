class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.22.1.tar.gz"
  sha256 "ad46cc624f318a9493aa62fc9612a450564fe20ba93c689e0ad856bff3c64c5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "18ef90d9ebc392e2b7f236b9dc9129491d7e095064d6228175655b6e5cffbea7" => :catalina
    sha256 "88cf84c51bd44fc4cfad2b14540973990dba3420be794ac8c257a8579dda9d5c" => :mojave
    sha256 "a86a950148e53d4942afc662b872cee01d7e6a9898b1a6784904d76e686a2469" => :high_sierra
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
