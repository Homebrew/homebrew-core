class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.5.1.tar.gz"
  sha256 "784a6f99001f2000422b676e637fe83a5dc27f5fc55ad33e227c882ce20e6439"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17a640d9f978ea53a493a0a25a9933415d75ae33c9603df132a7ea5a708869eb"
    sha256 cellar: :any,                 arm64_monterey: "7f73cd522e22922998f413298446ad3ce5833d27ada76ff274f463946f609a4f"
    sha256 cellar: :any,                 arm64_big_sur:  "c7f1bdcc81caf5fe5be38bf12a6cad388d2f4af2e00425984b957601a3b95cfc"
    sha256 cellar: :any,                 ventura:        "b2d7ef24d95632abf6b2c5c0201f8e67d72c8e062e89cd211f2d9d12da7d608f"
    sha256 cellar: :any,                 monterey:       "07715b57308906eb249be0ed024f2654d5d465902a50dbc330920a78aa0224c7"
    sha256 cellar: :any,                 big_sur:        "fb26a58ede0e4e3dd1c3d4e2868c3aff83612074e1fb30cf672921a573915ca7"
    sha256 cellar: :any,                 catalina:       "e13e8d92e068ed65cb01d3f99ecead8f44051cc31082346ee75f1c20ca2d86f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "268361c7b38595c9856a75173ff14d537224a7e3102f2ea447ecdb1c7985bd62"
  end

  depends_on "rust" => :build
  depends_on "harfbuzz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
    depends_on "xclip"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.rs").write <<~EOF
      fn factorial(n: u64) -> u64 {
          match n {
              0 => 1,
              _ => n * factorial(n - 1),
          }
      }

      fn main() {
          println!("10! = {}", factorial(10));
      }
    EOF

    system bin/"silicon", "-o", "output.png", "test.rs"
    assert_predicate testpath/"output.png", :exist?
    expected_size = [894, 630]
    assert_equal expected_size, File.read("output.png")[0x10..0x18].unpack("NN")
  end
end
