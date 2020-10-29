class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.12.5/xrootd-4.12.5.tar.gz"
  sha256 "164c83171e0bfc4d15ed55abde5f8b4d6413aa516c6b1faefabca0e6ba18275f"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git"

  livecheck do
    url "http://xrootd.org/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "197ab8bf8564530157d3956408bc15a95ab3b7dc3616ee312292ce325cec655f" => :catalina
    sha256 "fda59892c853f5dbd525c3495d4bbd3776a93e762681e56afb82263f77908d63" => :mojave
    sha256 "d832213cdad3ef90e8c8bbf8f777b772ee00c0a10b2bb4005a2773d5383c808b" => :high_sierra
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
