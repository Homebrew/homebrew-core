class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.7.tar.gz"
  sha256 "525f6970eb818f822db75c1526b3122b1af078affa572dce303de37df5c7b088"
  license "LGPL-2.0-only"

  depends_on :macos

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    assert_match "IMHEAD", shell_output("#{bin}/imhead 2>&1", 1)
  end
end
