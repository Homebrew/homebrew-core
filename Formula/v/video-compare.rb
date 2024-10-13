class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240923.tar.gz"
  sha256 "65df2f033fced3e3b7e1a65d454d3035ac9f72d0f7e0cc15b0bff9734ca0d62a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1cc931f9834842719b2400f46013819525ed3008dbe54a531b04aebc8000ac45"
    sha256 cellar: :any,                 arm64_sonoma:  "c791af912fb4e0be760dbe829173211302d62c932dd790fb4168c878dcc58639"
    sha256 cellar: :any,                 arm64_ventura: "56849c569d596f5f620629d614250602f21fa7541ec34b118f76418f9fbdd827"
    sha256 cellar: :any,                 sonoma:        "36a2b4edf0e49d630790eb0b63996f8e50a1fee1005ae1b7e7739f8c6dc8c2b8"
    sha256 cellar: :any,                 ventura:       "f394fcd9ae554c2782afec61be964f169df66608c5dd43d67a538ed344416e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be16a3b461693d72952f9ce6e757812325baf0505472b09af3f499d6ea050053"
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
