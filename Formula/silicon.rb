class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.3.tar.gz"
  sha256 "68d64ade34ac571cf2d092f9a6f124e2c7d0441a91e3ba00ca1c8edcdd008630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c86c964cda89cdaae682dd8ab5b945da6596ebaaef72913f7af8ec87642dd68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eff39c0548c3343ac95f31882e756a71479d9ef083300e95cf128d9aaff36540"
    sha256 cellar: :any_skip_relocation, monterey:       "f0f92dfa72158ce5526cd04e5a79815da3f87f1d42f4a7f1264a4ca7ae166d19"
    sha256 cellar: :any_skip_relocation, big_sur:        "27f31389064da033eae7fa05d2f5d2b3e12bf44349879652ebd971802757d1ac"
    sha256 cellar: :any_skip_relocation, catalina:       "262b846fb34927ef56ad5e12e39e766875d6f0a5e9e4217bff55fe23b7a6675d"
    sha256 cellar: :any_skip_relocation, mojave:         "440068b068edee61d6a001c7095935121cfd4575aaf6d9d6379b9685cba97d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33e3ca032e5181d2fb741f5084944be9ab4bb8806e275a142d79296a450d081"
  end

  depends_on "rust" => :build

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
