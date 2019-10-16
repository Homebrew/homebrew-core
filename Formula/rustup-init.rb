class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.20.2.tar.gz"
  sha256 "4d47ef7468c615fd10fbb07a16c15754336263d7417ee1685dfbd6e3ec151084"

  bottle do
    cellar :any_skip_relocation
    sha256 "729d96e5da37a1973b5447ae27bd02854426b7e082209d1876e8612fe6d96475" => :catalina
    sha256 "a8b25151b5d1f7e7030659af4dd8f4c2de04179d07ca49cf985b493409db02d0" => :mojave
    sha256 "56b724bf10782cffb560484bc8d56c5ff6b546f9a672b83685db58c399e4bc51" => :high_sierra
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
