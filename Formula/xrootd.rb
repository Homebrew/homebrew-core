class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.4.0/xrootd-5.4.0.tar.gz"
  sha256 "23bf63bbc63c8fb45dad8b907a7692624f31427001a1688135e9c8d182a3ee7d"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d80a38bfc640861314bcd39de696bedbe24be00a5217ec78b4d62d3eccaaf16"
    sha256 cellar: :any,                 arm64_big_sur:  "2bbc10eaa6661e68288bfe0bd38ffc961c397e361ebd17e5e31bf7de0d01776a"
    sha256 cellar: :any,                 monterey:       "29606bfbc0efd6a40de2248526e4851d89549d7f1dda21978580b661bbde1dbf"
    sha256 cellar: :any,                 big_sur:        "b0f6240141856122f67070b4539d4cf637df28805c1bff53b691a9814c88baba"
    sha256 cellar: :any,                 catalina:       "bba5300c2d7aff0046f6e5483955c4dbdb4de6c96ef55a0ae5f312c344d7c779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3990bb497f5c8ddc460febf8050309de6b224645caaacf0fab03c960d52862"
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
