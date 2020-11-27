class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.12.5/xrootd-4.12.5.tar.gz"
  sha256 "164c83171e0bfc4d15ed55abde5f8b4d6413aa516c6b1faefabca0e6ba18275f"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "stable-4.12.x"

  livecheck do
    url "http://xrootd.org/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "93c151aa365834913a5a6ebe2110185acdbd7e61373776b4ef37c18e195a8e67" => :big_sur
    sha256 "22b2413b91bfc41aadc51bd16d7f25662b285065e1a2faca0cfb531191b69919" => :catalina
    sha256 "ca118b5416a139b7b65e847eaa1c3b5384dae26754fdb2fd86286ff9a8e06fd7" => :mojave
    sha256 "6b3e11548b8251999277d709c9c449f4ef92ae28265f65e6718db354f7c5bd6d" => :high_sierra
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
