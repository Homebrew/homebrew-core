class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20261004.tar.gz"
  sha256 "65555c2bb4f76dee86666ad047e3b335f9f486d036402faebf97bd40ada7209e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ccc8d41ab89cbc5765ffb70e4673b7a8511c5f6aca6e554b9c0db68847617595"
    sha256 cellar: :any, arm64_tahoe:       "d6b9db81b00a2041ec990736acc20378dc43f7a069fbb49afa2eb8a4a856036a"
    sha256 cellar: :any, arm64_sequoia:     "0d9969a4da45a79c4c00062435039fbad54e414d4b9591280501df47f67dbe20"
    sha256 cellar: :any, arm64_linux:       "dd464ac9fd35c15526000f6efd4c966a3e7b393d6f07ee2b6b64838559f67026"
    sha256 cellar: :any, x86_64_linux:      "f2a6c794eab2b4979b0571b188a08336eee0431bb7e01c77777aba1d4fd96653"
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
