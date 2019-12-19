class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.21.0.tar.gz"
  sha256 "5dc7e1b16ec57c8cf9015f7f2b9780c09527b5f8783e8d5a62ddae7553a9587b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eeae5fd83583db5ccaef4d02e7d4bab357dc3983ba28856240b21a16c7e31fe4" => :catalina
    sha256 "e5e40bdec0a7e7e370d841a1251142d872653bf2b1601a1d81889af21ef6a94f" => :mojave
    sha256 "da5d48864bb15a73c7d9b20cf338fd6840ce3f77c1083598ebeac12f1243e779" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
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
