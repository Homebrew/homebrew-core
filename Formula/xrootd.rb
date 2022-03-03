class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.4.2/xrootd-5.4.2.tar.gz"
  sha256 "d868ba5d8b71ec38f7a113d2d8f3e25bbcedc1bc23d21bba1686ddfdb2b900c1"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ab9648c132f5d46d20e981426c3a099c9b0c58ac39a48e8abc67a2de610fdfe0"
    sha256 cellar: :any,                 arm64_big_sur:  "f8c4bb0697aba4bc1db32f6342db977f8dcfface3ef2b46b206af4dbc8f493e5"
    sha256 cellar: :any,                 monterey:       "e469c3a0c2648342fa28a97e4c58f8b843c1d54cf44d8dbdc78fc668a42c8938"
    sha256 cellar: :any,                 big_sur:        "5c701131bf75722601bd7ef2acdc5f8172bf2d32ba84cbaa1c5e3b2459140210"
    sha256 cellar: :any,                 catalina:       "10456f773e443657beaa449002f61076a40ced8af91d36a33fefbf25bc40f523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c2a61c9941103358c21f7871ade2ca2f9b614b27cb9c6c6fbde5ed149ae0d0"
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
