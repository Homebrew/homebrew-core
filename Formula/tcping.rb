class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "https://github.com/mkirchner/tcping"
  url "https://github.com/mkirchner/tcping/archive/1.3.6.tar.gz"
  sha256 "a731f0e48ff931d7b2a0e896e4db40867043740fe901dd225780f2164fdbdcf3"
  license "LGPL-3.0"
  head "https://github.com/mkirchner/tcping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cf829fa6b3feab933a12f8fbc9fc1e8d585a304f31d918f26ba0d502f4772ab" => :catalina
    sha256 "d769f344e5bdda11b8f0ce6c931e865e982166b3b504cdce33d58c9029786c60" => :mojave
    sha256 "e0d7d617ac3f98158cd25a08728f9f44cce132101368cae250cced7dbb6a0f7a" => :high_sierra
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "www.google.com", "80"
  end
end
