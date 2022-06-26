class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.4.3/xrootd-5.4.3.tar.gz"
  sha256 "2d58210161ef61fabad7c86a038f2ef71c2ba1a0e782fcb6b8c92a1ba5f2a2b3"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "081154adf4c5367d22755db6cf6e3176032a611c277953abde1bd1e4693078bc"
    sha256 cellar: :any,                 arm64_big_sur:  "55dbcea7a5f8ac03ff3f04358006dc20cd182591569fd5d1617776b2d4a71aed"
    sha256 cellar: :any,                 monterey:       "823cf1ec31a5703948c43a900a1670523308fbccb0f99c152066971ec2c52ee7"
    sha256 cellar: :any,                 big_sur:        "5a522c694b8fc5de0b9f60268ddebfd7eb80785c5ef50fa2df714a6f27394ac2"
    sha256 cellar: :any,                 catalina:       "2a95ac777ed1a5b4ee9fcee3e095024f4b5a3d587ca6961788bf10e5bf2827f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c278ef074bee0cf1f54aececf039097819722a7494c13b5c2dfbf8d7afb0ec2a"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
