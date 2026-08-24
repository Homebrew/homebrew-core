class Zapp < Formula
  desc "Flash ZSA keyboards from your terminal"
  homepage "https://github.com/zsa/zapp"
  url "https://github.com/zsa/zapp/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "bb11f5efcb240bbe9a97a2dde7121c548405527ffaf4a94d078b382268730bf6"
  license "MIT"
  head "https://github.com/zsa/zapp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf12b1917c4f687265a2580e843e32c4bc7bfb3e2c29ed6346b4ab589a8dec46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f180e36973b4ea681b14cef37c86876ed79a3523dc1f04b6ac8ca5d36dbf6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e57e4d2c586450b0de0a96738dcdc280411574b9ee55047ea64631b6886376e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2dd6eb80036e4aecf309c38a18475ac2d2ed931c96e4d8bb457f96c85a371c1"
    sha256 cellar: :any,                 arm64_linux:   "c95f70065216867a13ea10d6da33f4e0de4e1a12fdd9bd0acdf818258bfccddf"
    sha256 cellar: :any,                 x86_64_linux:  "7b33fbd7deea1277ea88ed009cd7e926d83d2f1a1f3fb0d0bc39fbe4d293d65b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "zapp")
    (lib/"udev/rules.d").install Dir["udev/*.rules"] if OS.linux?
  end

  test do
    firmware = testpath/"invalid.bin"
    firmware.write "not valid firmware"

    output = shell_output("#{bin}/zapp flash #{firmware} 2>&1", 1)
    assert_match "Error: Failed to load firmware", output

    assert_match version.to_s, shell_output("#{bin}/zapp --version")
  end
end
