class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20250223.tar.gz"
  sha256 "199159f56191ff72b1851778b4516cd11f50f5af3f63c921891caec236e64267"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8968f0c35ad01140311cc1b14af4fd6bb91d0071c7f344b154f64a13c11ec59e"
    sha256 cellar: :any,                 arm64_sonoma:  "82264c1b8f9dbc2b7f2dd1432cbd4a61a0132a78b9b3637b105d36613ef21bef"
    sha256 cellar: :any,                 arm64_ventura: "01c93c9b857f4313a29a448594e3f0e4977a4f579656e47429e8a4784e2879c1"
    sha256 cellar: :any,                 sonoma:        "05183a1333a90285b4399f3a82ed641ea68b2764da7849b39212b1acae97f115"
    sha256 cellar: :any,                 ventura:       "923701c5a0f0caccfb9fc68d2853ec191dc6c5bdfca9b78daf70c570491675c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800a5ba6a51b4f351143f2a647507c94c74acd5efc123e3149f64ffdd33aa011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86de9b148b58a9fc0e065e13120d7e7077ebaba2e5f8eb3c9414a5c8f9ad7542"
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
