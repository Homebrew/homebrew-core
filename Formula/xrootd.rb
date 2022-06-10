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
    sha256 cellar: :any,                 arm64_monterey: "a31b4dd11a9a9c280e7ccf464c2de9e9c968764cd94d6d0fc04d730e52a6e7c3"
    sha256 cellar: :any,                 arm64_big_sur:  "83e7f8d40dcade1aadda407f1cb4aa7829fb9487559dd7c46c1433d30840e5db"
    sha256 cellar: :any,                 monterey:       "c3bf9bd545924bee81111887fc2878cf6cc175835ded9fa6d6dffe1d463f44cd"
    sha256 cellar: :any,                 big_sur:        "d8d7e2c7be0cd3a7143a539178f1579276c18db94548dd33f0d01af2c7ae7741"
    sha256 cellar: :any,                 catalina:       "59a890ea2b1e05b6bcb096bd18e7b458e64c1a5439fa4f4abb7059dd0a2fa399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f5e01f9aec897f55bb9c208e92f9fa3ca9f8e15c9d635b951bad4ed0eccdece"
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
