class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang-nursery/rustup.rs"
  url "https://github.com/rust-lang-nursery/rustup.rs/archive/1.14.0.tar.gz"
  sha256 "0c8ae3a30b90c5b3e277774a87f40eedaadda64d0108a3dd83aa74cfe2e9c1a3"

  bottle do
    sha256 "cf31b6b49d05a67299fb353eeb24eba85b1e4bdb2f336e12e6cf98e967333b86" => :mojave
    sha256 "166334f4bf7af2cc6335495b819768b72dc7bee50b570ba33f48df77ed344872" => :high_sierra
    sha256 "becab830323956eca35d690d749dc9f40f0456d087c7ce6596ba6655cc5285d9" => :sierra
    sha256 "3cc2809a672b5a2dd905ca3258d92352f105c89d5a9dae14b02fdddea9da990d" => :el_capitan
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
