class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.18.2.tar.gz"
  sha256 "03b82d66d1d2529f9b6ff052b40d8f5381336a7ada52a56dd1eb2a6a0c5b6905"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c32e5a854c6421f28717d154ebafe1c0212bbe2f732b65d9a18e12fb827d61d" => :mojave
    sha256 "4064097c73231be9bc4df507abf5cea2346c3f515155cbfbc585bdc30fa73822" => :high_sierra
    sha256 "71f8e72cb1ffb5eeaab1f544a762e6a38f6ec2d491dfeb5aa202d641191422d4" => :sierra
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
