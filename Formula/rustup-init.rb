class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.24.3.tar.gz"
  sha256 "24a8cede4ccbbf45ab7b8de141d92f47d1881bb546b3b9180d5a51dc0622d0f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34def73d02389248456f798b608ed5395349eb53d2495c36cc79f36a9863452a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a336985902c88764c8b5403f5045aa6a4e0780c07d0aa2b980754a35ff0ebeeb"
    sha256 cellar: :any_skip_relocation, catalina:      "1c9b526f407c9bd1b14ed34efe0b4c74ee6c7946618fd80d7f63953562bc3232"
    sha256 cellar: :any_skip_relocation, mojave:        "3d51e6ee4013b3dae0f1435b91e054d0d8bd80ba5e72e4b3412c8e7e635c5e7b"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
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
