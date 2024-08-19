class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "815d41775dd9cd399650addf8056f803f3f57e68438e8b38445ee727a56b4b2d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88fa342ff94f00149044ecd6f5fb126e104f13058b784e17cfe344eb6ca50b6b"
    sha256 cellar: :any,                 arm64_ventura:  "766d31b996f3b41dd4a8b1dd34e7ff6a7fe68d6f05dd27f7e7205f7176b892c5"
    sha256 cellar: :any,                 arm64_monterey: "ca9541fb80cb28ef973767d8dd0f1db2979f40653ca253b67491f3ea9f984259"
    sha256 cellar: :any,                 sonoma:         "218d94bdbf0f5c1e6ceff4bad2a5945094b1a7baadef0177c1ad3f9cde18fc1b"
    sha256 cellar: :any,                 ventura:        "051ac7f4d0d21dda5cb5a9372b0d9dedacf3c8b37fe7ae35b1860101c8ec7aa3"
    sha256 cellar: :any,                 monterey:       "310caff3239a9e6b7bd16db58bf203224d51ea7f0b12fdf5acfe3f0522e72b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa0cec538c14c858cd237c54b4660861fd9f0d60807134fde42fe971f6b8ee6"
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
