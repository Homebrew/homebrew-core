class StdoutTv < Formula
  desc "Stream YouTube videos as live ASCII art in your terminal"
  homepage "https://github.com/SameerVers3/stdout-tv"
  url "https://github.com/SameerVers3/stdout-tv/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "63c79292b85eb34fcb01682bbe79fb4816c256b1b9e299a2fc49f89a6360e5b3"
  license "MIT"

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "stdout-tv", shell_output("#{bin}/stdout-tv --help")
  end
end
