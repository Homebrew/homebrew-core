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
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "ec10800dc260fe5f5d3d2c8eaf59bcc4dd66b26e5ef6711d5d69cbdfa127890b"
    sha256 cellar: :any, big_sur:       "175899de5aa39c513c96846122deb2d39ce36a337a3bac290a8aab6b5e12df77"
    sha256 cellar: :any, catalina:      "6d8692b31b1075069e7e91f3544761fca89cc61bebcf196990b80cfc858be647"
    sha256 cellar: :any, mojave:        "e4b86a28028400f6e4f152af77b0784adaf7f0b65c4b2bdf6dece891cf45268a"
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
