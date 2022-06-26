class Webkit2png < Formula
  desc "Create screenshots of webpages from the terminal"
  homepage "https://www.paulhammond.org/webkit2png/"
  url "https://github.com/paulhammond/webkit2png/archive/v0.7.tar.gz"
  sha256 "9b810edb6f54cc23ba86b0212f203e6c3bbafc3cbdb62b9c33887548c91015bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad209d841f88f9b5d3a969e2493d853237c89234bd09dfc3d1aa2106832d2d7d"
  end

  # Requires Quartz, as well as other potentially Mac-only libraries
  depends_on :macos

  def install
    bin.install "webkit2png"
  end

  test do
    system "#{bin}/webkit2png", "--version"
  end
end
