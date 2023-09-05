class Shunit2 < Formula
  desc "Unit testing framework for Bourne-based shell scripts"
  homepage "https://github.com/kward/shunit2"
  url "https://github.com/kward/shunit2/archive/v2.1.8.tar.gz"
  sha256 "b2fed28ba7282e4878640395284e43f08a029a6c27632df73267c8043c71b60c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "82fc864cd6bb364a531df9a69168b8d8d8cc3df33bdba72308f43168ce32cd1d"
  end

  def install
    bin.install "shunit2"
  end

  test do
    system bin/"shunit2"
  end
end
