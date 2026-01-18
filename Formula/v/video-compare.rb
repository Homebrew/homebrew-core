class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260105.tar.gz"
  sha256 "943ca8b115a1c47de98a05d357a64439a3860b2e3df26047d7fb3d4931fd35f6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe816491460086fa2b8ef32160a44c0bd7e2a227c957160e1ad3869a059d3e79"
    sha256 cellar: :any,                 arm64_sequoia: "e5ebc90a3c55fc5de35661b225faa793d5d5c3fb22215dcf6015a28648970c8c"
    sha256 cellar: :any,                 arm64_sonoma:  "478fbb83106e9f528de69ac9512b126e70ddcb307bf85226f378d564ea1d4555"
    sha256 cellar: :any,                 sonoma:        "9de3a2ccab339202f6d6e60dc5160fd8fcaaf0310d2736f49572845754ccd410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca791b4a06a27df8a36945d843e1af94ed6d4e6613493b5134e7d2356baee87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af72c564034a7e65bf7e3648d877725692d0418d417c173d8c6c65d27a58368b"
  end

  depends_on "ffmpeg"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = spawn bin/"video-compare", testvideo, testvideo
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
