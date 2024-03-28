class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.27.0.tar.gz"
  sha256 "3d331ab97d75b03a1cc2b36b2f26cd0a16d681b79677512603f2262991950ad1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe0597a894036869478f85e9699d6842ee31f89087b675bc45052ef229e8fef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399234a5a960841a0fc41348cac0efb5f8e7926401dc01463fbaf9289488217f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1833fc3ffcc01993d5a717b95f7bafe74acfa1315e2ccc174de3b7a6666be855"
    sha256 cellar: :any_skip_relocation, sonoma:         "870867bdea82352df96a534859fc07d75cf4af4e24d7797dada8380c61dd1776"
    sha256 cellar: :any_skip_relocation, ventura:        "334b6421d2b4dcafd48b6ff9eaf43d0f31bdf91f8d1c6c0e609d45f4576fc0da"
    sha256 cellar: :any_skip_relocation, monterey:       "d882f55cab523ff781de41061113b16a66c1c6e5291af37b9fba4e2222c673ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d69498ba5c52988b2191a2aab7a0b8bfae2a1e86541de168739290bd6928a45"
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

  def caveats
    <<~EOS
      Please run `rustup-init` to initialize `rustup` and install other Rust components.
    EOS
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
