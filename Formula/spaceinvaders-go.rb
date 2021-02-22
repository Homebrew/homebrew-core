class SpaceinvadersGo < Formula
  desc "Space Invaders in your terminal written in Go"
  homepage "https://github.com/asib/spaceinvaders"
  url "https://github.com/asib/spaceinvaders/archive/v1.2.1.tar.gz"
  sha256 "3fef982b94784d34ac2ae68c1d5dec12e260974907bce83528fe3c4132bed377"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "20ecc3ccc4d2c28cc9251f14fccc66fbd88abe6edc64708a73ed5aaa7941e39c"
    sha256 cellar: :any_skip_relocation, catalina:    "221c4d6f495ed8b4c1db5c737b4ff08be55a65b2bd15fc1c3e43ae96e29726ba"
    sha256 cellar: :any_skip_relocation, mojave:      "3f6f5106ba62445e33e2181facd9644dde99bb0f527455e4b49cecdb56cb56aa"
    sha256 cellar: :any_skip_relocation, high_sierra: "5a512f039b4a9698eb5ce766798f462b134e98944e07ab3eccf712ee35c811d1"
    sha256 cellar: :any_skip_relocation, sierra:      "672db5956f42626d3e9fc18defe431c4f2c18cd647f8cd534f9f522c314a0c49"
    sha256 cellar: :any_skip_relocation, el_capitan:  "2ac0b623df41e8c9e9da05fc7f21e842bce1e71c0b9d4db52ef685cca9e040b0"
    sha256 cellar: :any_skip_relocation, yosemite:    "99a7e2c353d5dbb310fa03e4a430d05e0092cb0aee1c19e38bd592492ae16487"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "-o", bin/"spaceinvaders"
  end

  test do
    IO.popen("#{bin}/spaceinvaders", "r+") do |pipe|
      pipe.puts "q"
      pipe.close_write
      pipe.close
    end
  end
end
