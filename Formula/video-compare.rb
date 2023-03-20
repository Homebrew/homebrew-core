class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20230311.tar.gz"
  sha256 "83f5bb685e511f8faa9eb482f5f3a724a612d2012eaa58e780d454d58df75f39"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c01be1a066dc0440322413a909e8ece4bc9c4be686bfc52e8e12356c80312754"
    sha256 cellar: :any,                 arm64_monterey: "ff717128674515b53eb342beb5d11afdd5bb419450cd84753dea25c9e106bae9"
    sha256 cellar: :any,                 arm64_big_sur:  "bce04f6386ddb06067604c7a6ae1acace835e7505dd60d0b52c67cfd590564d5"
    sha256 cellar: :any,                 ventura:        "c6e9ff5293f1cff468016469ee679d943e7d8c8b357b86ced850dc46d86fd5e3"
    sha256 cellar: :any,                 monterey:       "c1a555b42dc25787ae9665dfdc9e64ea401c590359a32ec1bcb4f70638d660bf"
    sha256 cellar: :any,                 big_sur:        "f0649243205c01e4487c97a46180470b12e86ef3bde5f650e7146ed20d28fac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84609aa054ff9f6670300c341737b0a81b05e4d5ec2b545dd6cb2d68a6fb4bd0"
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
