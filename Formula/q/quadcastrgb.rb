class Quadcastrgb < Formula
  desc "Set RGB lights on HyperX QuadCast S and Duocast microphones"
  homepage "https://ors1mer.xyz/quadcastrgb.html"
  url "https://ors1mer.xyz/downloads/quadcastrgb-1.0.5.tgz"
  sha256 "cdbe8d638ac772579acca203bb2663d7c3a47006190a78ee2971b06c63c69648"
  license "GPL-2.0-only"
  head "https://github.com/Ors1mer/QuadcastRGB.git", branch: "main"

  livecheck do
    url :homepage
    regex(/quadcastrgb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f5fd1f115292a34a1d8c04ff306313c41c37d97a174d933d08197654e6dc2ea"
    sha256 cellar: :any,                 arm64_sequoia: "e1684c8f4af8812803239f4a03601d5eaf2ac7e6ed0f49be43968e3b0f41b60a"
    sha256 cellar: :any,                 arm64_sonoma:  "136dd48804bc7f5d90f3f1b50c069ac5c95a898dc3a78e987bdab56ccdca72d7"
    sha256 cellar: :any,                 arm64_ventura: "9107904542014591dbd2f97c66ce1363da3725a5ff3064ad3339d58872a4f71f"
    sha256 cellar: :any,                 sonoma:        "a48b6ff4a332dfb6fb30312ef091372bf4f84d73692ec73e041fe1df4af8b8aa"
    sha256 cellar: :any,                 ventura:       "0a057c592b4dc9bd1475ecdee53f4c055a5c9cd0e4831cbbe6db94877f57e98d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6310f846898c6bf48c71a78426a47015594bf4b96f2a522ae9dde2d1716e8565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2801d5cd4a174741bc30148f65714b4aa8fcf15a97294df3e7482bb088bd6d56"
  end

  depends_on "make" => :build
  depends_on "libusb"

  def install
    system "make", OS.mac? ? "OS=macos" : "OS=linux", "quadcastrgb"
    bin.install "quadcastrgb"
    man1.install "man/quadcastrgb.1.gz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quadcastrgb --version")
    assert_match "No mode specified (solid|blink|cycle|lightning|wave)",
                 shell_output("#{bin}/quadcastrgb 2>&1", 1)
    assert_match "Unknown option: bad_mode",
                 shell_output("#{bin}/quadcastrgb bad_mode 2>&1", 1)
  end
end
