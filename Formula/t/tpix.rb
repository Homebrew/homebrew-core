class Tpix < Formula
  desc "Simple terminal image viewer using the Kitty graphics protocol"
  homepage "https://github.com/jesvedberg/tpix"
  url "https://github.com/jesvedberg/tpix/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2d9fb663a9aea3137d2d56fd470e2862ee752beac5aef2988755d2ad06808dd9"
  license "MIT"
  head "https://github.com/jesvedberg/tpix.git", branch: "master"

  depends_on "nim" => :build

  def install
    system "nimble", "build", "-y", "-d:release", "--verbose"

    bin.install "tpix"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpix --version")
  end
end
