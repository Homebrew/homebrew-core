class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20250126.tar.gz"
  sha256 "44e7d422c99c6a9f04b45dedbca0c6cf09025720def04bcfb8075890e9a07d3d"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4e5691720c6bb37d264886ce536a22afa912b39506c3c413f0b8ccc04d28065"
    sha256 cellar: :any,                 arm64_sonoma:  "da446766ca13d581b4732eadefaca81181a5638f0f57ae6af9e4fd7b83a53612"
    sha256 cellar: :any,                 arm64_ventura: "ab6f5f2190ea48e2ca676a1cd2cefdba5bd87f1dafe11d84a1dbe655364d9380"
    sha256 cellar: :any,                 sonoma:        "61035363edd174e71ec992a18a486e27d674cd7a37f7f9844c447adbbb0765ac"
    sha256 cellar: :any,                 ventura:       "3f004ead1274720b1960c651aa115384efd299d01111f0f6d458efc5fcd7494c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8d55323437603350de869e4085e0a66b9dbde104dfe2bb58cf31be76a70f14"
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
      pid = fork do
        exec bin/"video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
