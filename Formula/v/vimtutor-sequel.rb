class VimtutorSequel < Formula
  desc "Advanced vimtutor for intermediate vim users"
  homepage "https://github.com/micahkepe/vimtutor-sequel"
  url "https://github.com/micahkepe/vimtutor-sequel/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c02ae36fcf847e619a2b3774c6e2f00b8c08d7df77047fb169d694d96aed76d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4861ae2b888e47e777fd3f78ef878aea6b007147ec561ecc430d7abb61a85cb0"
  end

  depends_on "vim"

  def install
    bin.install "vimtutor-sequel.sh" => "vimtutor-sequel"
    pkgshare.install "vimtutor-sequel.txt"
    pkgshare.install "vimtutor-sequel.vimrc"
  end

  test do
    assert_match "Vimtutor Sequel version #{version}", shell_output("#{bin}/vimtutor-sequel --version")
  end
end
