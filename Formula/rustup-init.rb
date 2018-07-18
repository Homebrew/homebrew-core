class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"
  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.13.0.tar.gz"
  sha256 "9671934a6352366d8055769f1f5b297d9a15b4448634ee9fdf7c31c246fa5a4e"

  bottle do
    sha256 "166334f4bf7af2cc6335495b819768b72dc7bee50b570ba33f48df77ed344872" => :high_sierra
    sha256 "becab830323956eca35d690d749dc9f40f0456d087c7ce6596ba6655cc5285d9" => :sierra
    sha256 "3cc2809a672b5a2dd905ca3258d92352f105c89d5a9dae14b02fdddea9da990d" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--root", prefix
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
