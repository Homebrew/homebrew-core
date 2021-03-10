class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.1.1/xrootd-5.1.1.tar.gz"
  sha256 "b5fcaa21dad617bacf46deb56f1961d439505f13e41bf11f2d9a64fe3fb31800"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git"

  livecheck do
    url "http://xrootd.org/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "7f84642f75addc8884b6d99582b47d2ca7944f396f43f576a65f8cb47903d61c"
    sha256 cellar: :any, catalina: "620f6885a4a45c5587723d71246b10980a2585a2b99687c3b75e8109b5823377"
    sha256 cellar: :any, mojave:   "396d45c66c01f0a5faf729fb7ae7e84962ee6c5b602ef249b3d1857e4e003857"
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
      system "cmake", "..", *std_cmake_args,
                            "-DENABLE_PYTHON=OFF",
                            "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
