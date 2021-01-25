class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.0.3/xrootd-5.0.3.tar.gz"
  sha256 "be40a1897d6c1f153d3e23c39fe96e45063bfafc3cc073db88a1a9531db79ac5"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git"

  livecheck do
    url "http://xrootd.org/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "7f84642f75addc8884b6d99582b47d2ca7944f396f43f576a65f8cb47903d61c" => :big_sur
    sha256 "620f6885a4a45c5587723d71246b10980a2585a2b99687c3b75e8109b5823377" => :catalina
    sha256 "396d45c66c01f0a5faf729fb7ae7e84962ee6c5b602ef249b3d1857e4e003857" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
