class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20250825.tar.gz"
  sha256 "b71dd752ba6df3f86b653bb342720fdb899aee655722bdaa810046619e9bc02b"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41687f34ffe1536c24cd02af3829454eec36532648c1f80e6e950fd2f942f628"
    sha256 cellar: :any,                 arm64_sonoma:  "e7b214c6abf85ba94a9f9506da91e20bd799f79e94ab2c49acd8ad2b4a2c07fa"
    sha256 cellar: :any,                 arm64_ventura: "1913257718bca301fe66589be49a20487f9949700855f8e4ce6f5fa7282e7f9c"
    sha256 cellar: :any,                 sonoma:        "d21709fe3c8a0a535d0492be922d77c1009678124ff1897610d751bd409f2904"
    sha256 cellar: :any,                 ventura:       "06c56c8f3a5627f365cb2271c81fb973a5c333d1a1918d8c086b040be7266308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ca54e70bbcb2369d1074665f1cc680a8b5ef384940cfeb07be1363aa5ed967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4079f54aeb66e9e8f5cb032cf67b4e0e0038d3508677553081e99d2025922a"
  end

  depends_on "ffmpeg@7"
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
