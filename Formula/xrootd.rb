class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.3.0/xrootd-5.3.0.tar.gz"
  sha256 "1c833358647cdf3077f2f1f95b349b6982768cd3e477d81829e8df936644881f"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "67b0c4a51ec342648a589c5a9ea530f6ce0a700c7c6880fb9221cee5f863dab1"
    sha256 cellar: :any,                 big_sur:       "3595d7cd9362a5cbbd805be13ed8fa26b15ec0299ce63394ba731f01d7f959fb"
    sha256 cellar: :any,                 catalina:      "183a5dd5cd77cd3f317f34d6a1bf62c828e63dbe86c5a92d5f51c2582ba1a3f5"
    sha256 cellar: :any,                 mojave:        "fe31b5c6a187e22c23aaeefd5c0d45489c23223b79d9bb9306cf23027e8f1fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895b67b6ce5bdba64184099b7b850328de2ac6c5b95748d75725d9e06424c504"
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
