class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260308.tar.gz"
  sha256 "9e25b2a72f0c745637903cf1d3df71f32c040a610b64cb3d049831cafe1e2941"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8fddd93d8610b423d4e89de72db1cfcef64133e2c40db3bb94d627587efe37e"
    sha256 cellar: :any,                 arm64_sequoia: "06a84854a6f3208fb2cf73abec3b33d922176491bb078b774434a6b12fa6bc5f"
    sha256 cellar: :any,                 arm64_sonoma:  "bd66d5c35e4ffc84c0fba88c014ee5750f6397799978f34f89222c1319591e3a"
    sha256 cellar: :any,                 sonoma:        "f27d5c558c11528c41d769b6444ae604a1b4904e25c363fd8720ad0484440c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458fee5ace31fbe713ff4c84d5b09eab2be7b94475a9d12300f850e6c5b3956a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb906b7486530a942c8b605c3cb1005b157a1a8c09158e36479474c7fb51b79d"
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
      pid = spawn bin/"video-compare", testvideo, testvideo
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
