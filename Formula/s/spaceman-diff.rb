class SpacemanDiff < Formula
  desc "Diff images from the command-line"
  homepage "https://github.com/holman/spaceman-diff"
  url "https://github.com/holman/spaceman-diff/archive/v1.0.3.tar.gz"
  sha256 "347bf7d32d6c2905f865b90c5e6f4ee2cd043159b61020381f49639ed5750fdf"
  license "MIT"
  head "https://github.com/holman/spaceman-diff.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0d052a90fc7c951c2f8e3b75ec776f77486b99ce89a3c87273f92e5c46b9973b"
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
