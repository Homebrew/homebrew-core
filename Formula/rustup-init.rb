class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"
  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.14.0.tar.gz"
  sha256 "0c8ae3a30b90c5b3e277774a87f40eedaadda64d0108a3dd83aa74cfe2e9c1a3"

  bottle do
    sha256 "11ccb4a96d2927f6509534e699cc9302e1fba469162fe6c8a236cf54b1d0064c" => :mojave
    sha256 "ffdd7ba2f76fce891b3d1bdaf405b864167f0b1a330caa81185477c22006d93b" => :high_sierra
    sha256 "9979dbb7591a8b90ce5b49ababc02159d5ec423a76b282b03eaa6f7fa05eb7be" => :sierra
    sha256 "871a6357e0c95aaa4e293ed1daf609397339a7035dc83a51b10597c72b1380ef" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--root", prefix, "--path", "."
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
