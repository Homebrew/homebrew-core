class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20261123.tar.gz"
  sha256 "4318bc4778697ab8d6aaafbee234f537eeec897bccc583297435200efa00a027"
  license "GPL-2.0-only"

  bottle do
    manifest_sha256 "866da748de75e18328560ce97b9723f9688ae8c45114c1b9cf4039dc9a10b5fc"
    sha256 cellar: :any, arm64_golden_gate: "aa6097ad2be8995d586bb508d12339e2e87fc974b8f7a7b8a14ae5174f3b4604"
    sha256 cellar: :any, arm64_tahoe:       "256c31bc48fc499457c3ba80bdba35f407524a8c59c089fc2862b7431a1639fd"
    sha256 cellar: :any, arm64_sequoia:     "85552dd3ebf49d8126afcb960054698141aca0a780432e294c46362563548908"
    sha256 cellar: :any, arm64_linux:       "02616cb7d49c5e17445ddb7ec67a91a921bd687231e6ba328b4b16cf1898b5e5"
    sha256 cellar: :any, x86_64_linux:      "9cca4adf3450321cbd04e522363ce2359d280d9b4b89450dd7889ea575d1a824"
  end

  depends_on "ffmpeg"
  depends_on "sdl2-compat"
  depends_on "sdl2_ttf"

  deny_network_access!

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    with_test_process(bin/"video-compare", testvideo, testvideo) do
      sleep 3
    end
  end
end
