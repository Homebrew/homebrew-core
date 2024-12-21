class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20241221.tar.gz"
  sha256 "7ce3bd2f56ea72d6d9fecd27ea09670aacd82bf446a662ea69ce462f7d5ebfba"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a1658f9283efdd49f3028330c7a7857cac89ed4e7b15906865fc31492f863bc"
    sha256 cellar: :any,                 arm64_sonoma:  "d16880c428b51e97973a91f48ca54e4bf1a0f6ab23e65a4c3f2a682bc97a691e"
    sha256 cellar: :any,                 arm64_ventura: "bd97f7fdd98d2f6014563f34787cbc9535cfab0435ff480c4ec81f943a5e9789"
    sha256 cellar: :any,                 sonoma:        "e9f39094571a582cbfebbb7f8d6cd410ce7b19fd805c1ff31fa60f03e9fa219c"
    sha256 cellar: :any,                 ventura:       "f662ef8870b01f0d789b1702ebfd2999b18ace602ec33d8d53dd9159053090fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b027280395b134bb444a60c8d1cbe588886c14472174f6ba6c41d41698b21876"
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
