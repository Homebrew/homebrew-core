class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.25.2.tar.gz"
  sha256 "dc9bb5d3dbac5cea9afa9b9c3c96fcf644a1e7ed6188a6b419dfe3605223b5f3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f17c91641ec51f96882e560cf153633d75a86ffc0694849f1ec3af3374cde3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d5f670eb0ff3f8d6854e8186131b57173691e3ebc44ea7c4fd7b964b643fab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90ada375a1415dd658664a84686ba0076b8024e0895dd4ee4bfbe325fb35f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "9f37940043950ca725bc75c6e73d795908ec224baed0257f116f825bcbb7b92d"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a955dc86df7e4db6b842c1396608c75f37db267ba943d3174af009d32f1d2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4f1c224cbe4042cc2dd2fce2c22771d53dab0cdb523e4a81c982d1adad45e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c749c63b8a4e4f3aecfbd73a22505fbf7d908c611f371b384d305b6639e47546"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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
