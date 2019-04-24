class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.18.0.tar.gz"
  sha256 "d0a3c832d866a9408e272e0b54748dcb1261d7b0669d44b69efca7542e0677f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a4d94e6eedf786c1394883c7dc3f4133a658ae93c78bd98103991441c49be6f" => :mojave
    sha256 "3b86d51f5af4973199bb3d9ac8f3f9c32d133f32d3feed07717554aa9d769cfd" => :high_sierra
    sha256 "59593630618347b2996c1cab5696da0b3bc306aba84b1569233fb103c2565b09" => :sierra
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
