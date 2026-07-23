class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260708.tar.gz"
  sha256 "ddb012b4f47c7c373de9f9007e00200cf887c49057addd689cc4ebfddd7ae4ce"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f52a68e6aeb37b61cdd2ad00a3a49509049f45596c3ca7807b646a9075293694"
    sha256 cellar: :any, arm64_sequoia: "a51390a8d0e00dba570308a1baed3608a6c5fa5e17bfef90c57be8ae16964506"
    sha256 cellar: :any, arm64_sonoma:  "755c6eea66a3972149af11134cf93940255216e32dbb0a6411c960a98c14c26e"
    sha256 cellar: :any, sonoma:        "016773119d7ae3a1520a16d814c87bb61c576cf5d0cbf1a48d3ea83c9af38b10"
    sha256 cellar: :any, arm64_linux:   "93301d4f684728856af35dfa3a18821ebb7f77eb49dcc19821dcd7d50550d586"
    sha256 cellar: :any, x86_64_linux:  "59a443acf40d48ac7e54414d3173077bba16cebcde9145bb06b0da790d167065"
  end

  depends_on "ffmpeg"
  depends_on "sdl2-compat"
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
