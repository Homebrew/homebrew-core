class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.5.1/xrootd-5.5.1.tar.gz"
  sha256 "3556d5afcae20ed9a12c89229d515492f6c6f94f829a3d537f5880fcd2fa77e4"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2977803b0ad82bab2bcd695a2367af781a3e9e97d76507edc45a7eb862a8ff57"
    sha256 cellar: :any,                 arm64_monterey: "1c167ab2da3c4f78eaa80b5306ee8cbf015a8d29db420bfcd79eecfd9d53a514"
    sha256 cellar: :any,                 arm64_big_sur:  "8b87fe62c1ce8698d7cb34fec96eaf2b5333719027638895d6264413ed21bae8"
    sha256 cellar: :any,                 ventura:        "ddfa75293506519ded76e9d0c2611736d98ab9750a2cec180ec2d98e5ca39f4e"
    sha256 cellar: :any,                 monterey:       "19af39f982ea8059f26bb6fe352cd0b0bba7bef3bda1648fb5a34849dbeb3487"
    sha256 cellar: :any,                 big_sur:        "c4d34d6f0aadb5a94f1b9338ed839009f0d7236761b51e7bb88a1f2f625dba40"
    sha256 cellar: :any,                 catalina:       "56b5e1f2161ac941a50a656134024aeb0d924fc8477a6f158fe2db2b226340a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e665252ff42f1e3283c1ca42ea94d28ec43641fd8665d67db4dd833cb070ddbd"
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
