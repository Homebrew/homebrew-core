class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "https://neil.brown.name/blog/20100324064620"
  url "https://neil.brown.name/wiggle/wiggle-1.1.tar.gz"
  sha256 "3da3cf6a456dd1415d2644e345f9831eb2912c6fa8dfa5d63d9bf49d744abff3"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9ec785cabc40fb4879c63982bf85cd1412d411fa33775b7e1e3f53dc1df977b" => :high_sierra
    sha256 "0f002fb282dfaa1df66f28cd3f2135b571095b4f5db5528e288dcf439d480a2f" => :sierra
    sha256 "7e832c2b0e4e4564f15c3a66b1d0b78c309a0f28ca548b5e39b6967bdf12a542" => :el_capitan
    sha256 "e6799084357708eb5142ec5c1104f43c9fdcc0d953f0b80c458e931f53e210e8" => :yosemite
    sha256 "09c23ec2dce1bc70a93671b85780f47f9bbb24c024a48cbfa9c3a13b79b048a5" => :mavericks
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end
end
