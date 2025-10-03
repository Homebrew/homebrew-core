class Slugify < Formula
  desc "Convert filenames and directories to a web friendly format"
  homepage "https://github.com/benlinton/slugify"
  url "https://github.com/benlinton/slugify/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f6873b062119d3eaa7d89254fc6e241debf074da02e3189f12e08b372af096e5"
  license "MIT"
  head "https://github.com/benlinton/slugify.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3b484ae7b5d87f4f148f8c9395960213ed62b4cd1b82567c7bcceede23259942"
  end

  def install
    bin.install "slugify"
    man1.install "slugify.1"
  end

  test do
    system bin/"slugify", "-n", "dry_run.txt"
  end
end
