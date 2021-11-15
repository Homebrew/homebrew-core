class SpacemanDiff < Formula
  desc "Diff images from the command-line"
  homepage "https://github.com/holman/spaceman-diff"
  url "https://github.com/holman/spaceman-diff/archive/v1.0.3.tar.gz"
  sha256 "347bf7d32d6c2905f865b90c5e6f4ee2cd043159b61020381f49639ed5750fdf"
  license "MIT"
  head "https://github.com/holman/spaceman-diff.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66c940e56f22cd2f5fdb3cfd2e1ddd741400c0739bb91ded95f5ddf5fa3c9902"
  end

  depends_on "imagemagick"
  depends_on "jp2a"

  def install
    bin.install "spaceman-diff"
  end

  test do
    output = shell_output("#{bin}/spaceman-diff")
    assert_match "USAGE", output

    png = test_fixtures("test.png")
    system "script", "-q", "/dev/null", "#{bin}/spaceman-diff", png, "a190ba", "100644", png, "000000", "100644"
  end
end
