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
    sha256 arm64_big_sur: "805f3c09b8a549c90bf143ab879a00a45566c199c9c9d90faff51b9ade6db21d"
    sha256 big_sur:       "47e2ef9a7acfa8bafe7818a55c762d2bc3ca07303e61a2ac8924efcccdaa8ef6"
    sha256 catalina:      "c8b0263052a469dac59ac2d35dc94c5ecb92daae1695af20aab120a79ce74c84"
    sha256 mojave:        "4ca621cc2d357d7a31f03883687aa1b8a56f7b7111a616a5bb9747342982b0c5"
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
