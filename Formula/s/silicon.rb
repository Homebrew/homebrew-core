class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "56e7f3be4118320b64e37a174cc2294484e27b019c59908c0a96680a5ae3ad58"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c4f89277fc20079a76958b8b4f6fe533cb555ecdea671f3c852ea2bbc530627"
    sha256 cellar: :any,                 arm64_sequoia: "3344abcb48d22efadadc415e5beff9ba197e3309e813549a3afdd459a99324f3"
    sha256 cellar: :any,                 arm64_sonoma:  "27d8515dce15d3bef3d394794192c6b8b6b33786152c6df4ef524ca6de112126"
    sha256 cellar: :any,                 arm64_ventura: "8e64e4602354dff22bd4b5a7ca430842491c3b18ada1c63fc7f5cbb2ed9da945"
    sha256 cellar: :any,                 sonoma:        "6dddd3c3a90fcbf06dfade35bc46e276bbe6027d74326b8315fe9307a0d98146"
    sha256 cellar: :any,                 ventura:       "7fb5ed4ce9e2e6ed6ed44ad1e115090161852f129cb444a352547aca3c7b4002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ace34668e40622982946b0611cb2abceae9f9c2bcf5168c1a33bb338793d2176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe03c08e0975b4d4b1a90fdbfdf9c82767bd7b85becc71e72b4e63ed59b3074"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"

  on_linux do
    depends_on "libxcb"
    depends_on "xclip"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.rs").write <<~RUST
      fn factorial(n: u64) -> u64 {
          match n {
              0 => 1,
              _ => n * factorial(n - 1),
          }
      }

      fn main() {
          println!("10! = {}", factorial(10));
      }
    RUST

    system bin/"silicon", "-o", "output.png", "test.rs"
    assert_path_exists testpath/"output.png"
    expected_size = [894, 630]
    assert_equal expected_size, File.read("output.png")[0x10..0x18].unpack("NN")
  end
end
