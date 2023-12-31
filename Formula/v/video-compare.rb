class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20231224.tar.gz"
  sha256 "f681184b17f21aa82b67682c37d5fcb24c53057ca74c3c0096d68b9918ab842c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2832723efd2cd0173c3bd7357e61354d42a406dbcb62836cf227681a1865e6e9"
    sha256 cellar: :any,                 arm64_ventura:  "d6a0703f8f2a7609d618da9aaf43731cc02ae196167ba1643651113982e30d67"
    sha256 cellar: :any,                 arm64_monterey: "e9a798f3842b214689ea090676724e6e1fb50efb6ac99a0d51c7abd14b603e1f"
    sha256 cellar: :any,                 sonoma:         "4811d42390678ca584193da0b4ec7601c2a19cf9cd250378b9294502dd07efc4"
    sha256 cellar: :any,                 ventura:        "9f8fd6559c081edbfc705590350a83b715c619117392b424a964e03f08a17ef9"
    sha256 cellar: :any,                 monterey:       "9450d283015e2f56e2d1df2a767acac659222846b1b2c860bd3db6057e6b87c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2cae9d97dc0edd740c8659b177f8e06a29a7485c766b717f847b9a7fc7fde90"
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
        exec "#{bin}/video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
