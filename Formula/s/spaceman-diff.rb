class SpacemanDiff < Formula
  desc "Diff images from the command-line"
  homepage "https://github.com/holman/spaceman-diff"
  url "https://github.com/holman/spaceman-diff/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "347bf7d32d6c2905f865b90c5e6f4ee2cd043159b61020381f49639ed5750fdf"
  license "MIT"
  head "https://github.com/holman/spaceman-diff.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "36d9e7a82debbc9f11c998ed776c67172a8ee7dfc08ced8c840dc430c906fba1"
  end

  depends_on "imagemagick"
  depends_on "jp2a"

  def install
    bin.install "spaceman-diff"
  end

  test do
    # need to configure to use with git-diff
    output = shell_output(bin/"spaceman-diff")
    assert_match "spaceman-diff fileA shaA modeA fileB shaB modeB", output
  end
end
