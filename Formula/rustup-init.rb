class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.24.3.tar.gz"
  sha256 "24a8cede4ccbbf45ab7b8de141d92f47d1881bb546b3b9180d5a51dc0622d0f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e0c708bf0bc403fb5591b9f6991d709c68800ee230793cd587286c76c3711a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7de5aa4538303b308d1f136c475fdc83f8fa3b418da46a66cf8146a6f0d6ff2"
    sha256 cellar: :any_skip_relocation, monterey:       "588a4b849136c5a63094e24c348af1bc4c1d13f2a36d6b6e4d7287d49ed87385"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2bae6f97776cee5d796444ceb7c54f46e9dd56e51f9a1f439bbe7c842015572"
    sha256 cellar: :any_skip_relocation, catalina:       "7807b533709be5c92d7db4bd4189ae81ecf9f881544673591c7acb340d081b68"
    sha256 cellar: :any_skip_relocation, mojave:         "681169de63d0e8a0dddbbe88388a64c4c15963e9c5b0dbf4029e1f2e75778667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5057bb4cf8c5c4e314358aad6790c1df9917a096baa010cf9f1de1eeb940f6ef"
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
