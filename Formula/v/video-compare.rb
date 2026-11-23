class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20261123.tar.gz"
  sha256 "4318bc4778697ab8d6aaafbee234f537eeec897bccc583297435200efa00a027"
  license "GPL-2.0-only"

  bottle do
    manifest_sha256 "29d64e991449d7cd597fca9a38d281dc9832b99b4a400a529e1d1a06baeecbb4"
    sha256 cellar: :any, arm64_golden_gate: "8f449e11696b8fbbd61ae9ba1df431563d7e9705435a3ed5237916e25b1b08b6"
    sha256 cellar: :any, arm64_tahoe:       "1901eca689888b28198074faaf2f73c55a889cce0b1f784caf627e77da5c1690"
    sha256 cellar: :any, arm64_sequoia:     "db8b8d56aac607da3b7a606505a723262563f63bf6cb0f17b14f404b9e392a90"
    sha256 cellar: :any, arm64_linux:       "c37665f41d9f0d29ffb56ec57e77532ed050a4113bf46528d7183526a6c42f49"
    sha256 cellar: :any, x86_64_linux:      "1ada6c0f58127fb49c0b14a8845a384cbca6f4bddb5de323194c03a767508c49"
  end

  depends_on "ffmpeg"
  depends_on "sdl2-compat"
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
