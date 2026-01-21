class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20260120.tar.gz"
  sha256 "c4ee73031baa055a41e39a9872b5e4b08bed5801b1224886262ad94d6bd69da5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1338dff46ade41bcf520e332cc6ad05ff00933ae1dc5bcfdb3e3afc3c7278627"
    sha256 cellar: :any,                 arm64_sequoia: "6cb41e8f610a176c32a53b0463852402d20e01587b631bf5d4a851bd9f9ba6c0"
    sha256 cellar: :any,                 arm64_sonoma:  "f61600e309313ad54b9f163093e00dc2943baf6296fc0e962abfa61e48e10693"
    sha256 cellar: :any,                 sonoma:        "6db1244cde14782462ee9995bf083f2b81233597da492fe0e2dc3e31769deeae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ff96b71fc0894e41dd1b7f7a99239c2e00fa33378f29ff88a63709315271a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "749cc35aa6d05cabc44743340fbe32bd258f5c2eb8bc1ab4e14fc1d7f1361751"
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
