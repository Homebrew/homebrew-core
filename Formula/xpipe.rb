class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "http://www.netmeister.org/apps/xpipe-1.0.tar.gz"
  sha256 "6f15286f81720c23f1714d6f4999d388d29f67b6ac6cef427a43563322fb6dc1"
  license "BSD-2-Clause"

  def install
    system "make"
    bin.install "xpipe"
    man1.install "doc/xpipe.1"
  end

  test do
    system "false"
  end
end
