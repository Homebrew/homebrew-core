class Wcstools < Formula
  desc "Tools for using World Coordinate Systems (WCS) in astronomical images"
  homepage "http://tdc-www.harvard.edu/wcstools/"
  url "http://tdc-www.harvard.edu/software/wcstools/wcstools-3.9.5.tar.gz"
  sha256 "b2f9be55fdec29f0c640028a9986771bfd6ab3d2f633953e4c7cc3b410e5fe9c"

  def install
    system "make", "-f", "Makefile.osx", "all"

    prefix.install "bin"
  end

  test do
    assert_match "IMHEAD", shell_output("#{bin}/imhead 2>&1", 1)
  end
end
