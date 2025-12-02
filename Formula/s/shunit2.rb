class Shunit2 < Formula
  desc "Unit testing framework for Bourne-based shell scripts"
  homepage "https://github.com/kward/shunit2"
  url "https://github.com/kward/shunit2/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "b2fed28ba7282e4878640395284e43f08a029a6c27632df73267c8043c71b60c"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b706f44b77486bdf9fc7629b0fed435e9e5592055c847f7d2bda9f4ed84d8cc2"
  end

  def install
    bin.install "shunit2"
  end

  test do
    system bin/"shunit2"
  end
end
