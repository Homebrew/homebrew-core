class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20250825.tar.gz"
  sha256 "b71dd752ba6df3f86b653bb342720fdb899aee655722bdaa810046619e9bc02b"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f00c5852966f9e45ab2a4b11eafb61f8d989aee9930ce33a108a7e2b0b0da5b8"
    sha256 cellar: :any,                 arm64_sequoia: "ce07c35e3d8dd6401d458157701d901bdc545ee5d7cb214314591ea35810f0e6"
    sha256 cellar: :any,                 arm64_sonoma:  "3950652501dd07d382dded70a2a4853724e7747d55a95a743ade99ea4a2c3ad6"
    sha256 cellar: :any,                 arm64_ventura: "73f1a4a6ba9db4c25d1206f82b5a488eb297c9d6965fa59dfb0178cddc1fd96c"
    sha256 cellar: :any,                 sonoma:        "6e70856bb5f1adc6e3220b0b685f776bd59777c43eadb516d68a3211da8fe5be"
    sha256 cellar: :any,                 ventura:       "a01ce2449b88546908c836e357a719b477025be30e039b15f6a4cf71e59cdd0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f4dcbdd16466a70b96bce702fe5ba90818ee256ea09aeb4f5748696432963f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a3070d182a9c8bc52e00e603a6c62493bbbecba6b1028660523b05abb8e963"
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
