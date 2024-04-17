class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240303.tar.gz"
  sha256 "57c2b39ff80c4325f87fdf0f6b1fb4b388baf19cd660428518c205b57102e970"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a43266fcfe327139a6d6b1d8d6543bbed69ad28f9e3af4c8ae835e9b6c9d7d07"
    sha256 cellar: :any,                 arm64_ventura:  "eb591dc382268b7976e7100cae0a97a170e642b2236a9a060488d45287f56c53"
    sha256 cellar: :any,                 arm64_monterey: "08819b4dad9eba51e6e181e8d224e653547f4e4973b5854772cf1ed14ad6aff0"
    sha256 cellar: :any,                 sonoma:         "4b5a6cfc13abb40f23280fbae3d40fb5bb425ca92d48e33c2126aeebb75c4d14"
    sha256 cellar: :any,                 ventura:        "573decf9c0b41a6e96203881191fd9d40df47c531cc148f0278f58792de93b53"
    sha256 cellar: :any,                 monterey:       "cd8f0c7091da06e922e444335f1ed9983b7a902114f774e424d7ceaa94d5adc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c3d54976c4b33d88478ceb344d5ca1f5a73ce62ca0aa3b5c936189d56f14a4"
  end

  depends_on "ffmpeg@6"
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
