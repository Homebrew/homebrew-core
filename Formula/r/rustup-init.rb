class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.27.0.tar.gz"
  sha256 "3d331ab97d75b03a1cc2b36b2f26cd0a16d681b79677512603f2262991950ad1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23448f34076addfcb95eed04ba2bafcea32a25b57442e24baf1a92572ca0a9b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f83c1f987e10419ba71eaf6546249763c2cdc0ff0ec6ea08f9be56c675c1aa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ac8dd8c8bde9ef120cc83c221c6cb199a9865e7b95f991e37938ba7c5e9460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32ce314ca621607de3b0648729779a021f8b84f1c83348daa72c30c747394681"
    sha256 cellar: :any_skip_relocation, sonoma:         "e614a8ac90ec6811c649b32510987acc8e65222054359addba46d6b17af0c367"
    sha256 cellar: :any_skip_relocation, ventura:        "08b7293cdfa169876f17ed0fce082a27d8def0f6196a1797077c5db7eab91d35"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7610b4babb0b4cdfb7aad014ccef60901859197498b7e24cd6f3b8d833e9a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b1190e54377eade02a31d104e27793f4b752a3017f27f1579258531190f7e35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163975e8261a925c4c6082d937b9e1712f116ca6da619768fd309894885c6a60"
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
