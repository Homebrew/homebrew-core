class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "https://github.com/mkirchner/tcping"
  url "https://github.com/mkirchner/tcping/archive/1.3.6.tar.gz"
  sha256 "a731f0e48ff931d7b2a0e896e4db40867043740fe901dd225780f2164fdbdcf3"
  license "MIT"
  head "https://github.com/mkirchner/tcping.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ca791764d99fc9e263fbbc3352d1861def26900f099552fcfce866eb25934fe9" => :big_sur
    sha256 "77f44aef18a3e45cdb8ee8ed377b81173b142496db34666e29df3703ab93dcaf" => :arm64_big_sur
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
