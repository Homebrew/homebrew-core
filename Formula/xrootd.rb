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
    sha256 cellar: :any,                 arm64_monterey: "53c07b0982bb005408782eb035d3e815a8cd0d0bff7f258b1ead626c39ccba66"
    sha256 cellar: :any,                 arm64_big_sur:  "ed558e22a0a4450671776a041abee0523dc0d388bc84d278704c314cf562e0c3"
    sha256 cellar: :any,                 monterey:       "4df6a692c33fd59f33f0a213d6ee44480a76acc95af48ba157aabcb1bbc0b4ad"
    sha256 cellar: :any,                 big_sur:        "c2bfc586c71c003c98148888293d98237d573c43b31d2d827d588c269a12e87b"
    sha256 cellar: :any,                 catalina:       "89f0aa461ed5d48b54cce126c1a7b4d72a61863f3220d1ad893592ef541e32b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cab5ebc73b8bbb6b381a2f2e3b217de962e649df4f17dcb6e8701a205725c90"
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
