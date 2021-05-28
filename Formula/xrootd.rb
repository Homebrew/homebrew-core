class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.2.0/xrootd-5.2.0.tar.gz"
  sha256 "e4a90116bd4868c7738024a9091d5b393f649d891da97d7436d520b4a8f87859"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git"

  livecheck do
    url "http://xrootd.org/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "593caddee8c6d4bd3bd7a459102fb80664e87e10d87c813cf516048d06e7515c"
    sha256 cellar: :any, big_sur:       "4d55a47bf02b816ebb0b29548d13f00f4362d0129a96090c2e2070439c622cc6"
    sha256 cellar: :any, catalina:      "da545c476d69a8cc2392422f024fca77eb1c89d6a6e01c1945487f4be20d68a9"
    sha256 cellar: :any, mojave:        "2ab61f841f489a88971fd21c9c34fef05dbd4fc89913db227ea4cf203aca409e"
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
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
