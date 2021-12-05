class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.3.4/xrootd-5.3.4.tar.gz"
  sha256 "8e18a7c2aba6588ddc8c7ed4635247c35f5bca3741bfdea8b4e336f8c9adcd70"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "125b165586aef72874a20577c50a4c4d8e502bb078ac71285ea2e8a52df6cfb4"
    sha256 cellar: :any,                 arm64_big_sur:  "a409acd75077722ad8ab59a933c86b97e20a373c112a05175e35d0d21061fc08"
    sha256 cellar: :any,                 monterey:       "9a88e13af60a26b1a90635287913a4cefe068820cda850f232b0d221dafaa7be"
    sha256 cellar: :any,                 big_sur:        "910b4b7a1e0b39d2868ddcb69c6732b6f74362c3a381d4f70ac7cd880f15f471"
    sha256 cellar: :any,                 catalina:       "39ffd96d95a4c06f07050c3dacbfc7b1b0759ab44df6cabd62eabd02130dec66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3d6b6625a404a28060210c03c107fc6c3544c2d33e82e1fc0f37908c6ceaba"
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
