class Quadcastrgb < Formula
  desc "Set RGB lights on HyperX QuadCast S and Duocast microphones"
  homepage "https://ors1mer.xyz/quadcastrgb.html"
  url "https://ors1mer.xyz/downloads/quadcastrgb-1.0.5.tgz"
  sha256 "cdbe8d638ac772579acca203bb2663d7c3a47006190a78ee2971b06c63c69648"
  license "GPL-2.0-only"

  depends_on "make" => :build
  depends_on "libusb"

  def install
    system "make", OS.mac? ? "OS=macos" : "OS=linux", "quadcastrgb"
    bin.install "quadcastrgb"
    man1.install "man/quadcastrgb.1.gz"
  end

  test do
    assert_match "No mode specified (solid|blink|cycle|lightning|wave)", \
                 shell_output("#{bin}/quadcastrgb 2>&1", 1)
    assert_match "quadcastrgb version 1.0.5", \
                 shell_output("#{bin}/quadcastrgb --version")
  end
end
