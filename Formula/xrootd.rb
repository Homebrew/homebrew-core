class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.5.5/xrootd-5.5.5.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.5.5/xrootd-5.5.5.tar.gz"
  sha256 "0710caae527082e73d3bf8f9d1dffe95808afd3fcaaaa15ab0b937b8b226bc1f"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b436260226bdbb4140cfc93cae47e8e02b84c5b03afddd2ff87c3cf400d77c41"
    sha256 cellar: :any,                 arm64_monterey: "e8f41f836d0cc5845b1ade82d8cdf49ba7280ae5bbcc12a0ed1355a27e4d3859"
    sha256 cellar: :any,                 arm64_big_sur:  "ef970b0a7d0c77fbbfa7645194ff634f6d8805ce17e47e8e3148b39dec21f7fb"
    sha256 cellar: :any,                 ventura:        "067a3414604a7da0656246dc2ea0506f8e7af0c0189acede66f9c9238f4dce01"
    sha256 cellar: :any,                 monterey:       "0628e8e25569054c78eb4f4c52401a6fd543f49019b4744f0a985c22dc86be57"
    sha256 cellar: :any,                 big_sur:        "78f08a3d8bab5f1a49cb9e23109ccea694fe50739da2e88d143912fbd53123af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fe3dcb4c78e0c1ac418f9955f0cfe35c5d7c7fd33ee0d9a584e5a50e809f42"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
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
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_CRYPTO=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
      -DENABLE_READLINE=ON
      -DENABLE_SCITOKENS=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_VOMS=OFF
      -DENABLE_XRDCL=ON
      -DENABLE_XRDCLHTTP=ON
      -DENABLE_XRDEC=OFF
      -DXRDCL_LIB_ONLY=OFF
      -DXRDCL_ONLY=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/xrootd", "-H"
    system "python3.11", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
