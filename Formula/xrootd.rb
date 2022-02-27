class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.4.1/xrootd-5.4.1.tar.gz"
  sha256 "c0e7bb1a992f1dac68790d0ffaf051c4c52c79491feab42c6db3fbd50b462a39"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2a5aefe008650dd5e01a1d71cfbb2395ac2a0444902ea7179664057597665c0"
    sha256 cellar: :any,                 arm64_big_sur:  "9167abc89bd89afb1657dfd64b6e2cbece205aa9a49b44d4c3e2efc9602ba7cd"
    sha256 cellar: :any,                 monterey:       "769d801771e6ee7bb3a06c8c31f4d10e88054aedfae8babc26a0809ca04fa86c"
    sha256 cellar: :any,                 big_sur:        "eb29f32da099a9efe0605ada9fde2b4dd67799ac6a9be7ac07cbb32a78df093b"
    sha256 cellar: :any,                 catalina:       "5077903be9fe376f9a2bb53682b677bd78b0bb8e3bce93542681d8cfc0977178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff574603392f40dcbb5f133440a1de1aafea712299069ab56fca4e849b3df2ff"
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
