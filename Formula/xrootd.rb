class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.5.5/xrootd-5.5.5.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.5.5/xrootd-5.5.5.tar.gz"
  sha256 "0710caae527082e73d3bf8f9d1dffe95808afd3fcaaaa15ab0b937b8b226bc1f"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bb580a880af4d430caead2391c1480c1d6fec45f1defbe1e92a649220c462d22"
    sha256 cellar: :any,                 arm64_monterey: "faea539151e836ab1b6a6b94ec3252301ccdd6d9b481a18a8311a114a803e850"
    sha256 cellar: :any,                 arm64_big_sur:  "93b1eb1ed93ad8cb64eb00f2e2ab4469b24470a3e16b1c5109c444ac87201159"
    sha256 cellar: :any,                 ventura:        "dcf6407d041d70438b45a5bb9516985dda902d72db5d8e090e5662c25cdbf23b"
    sha256 cellar: :any,                 monterey:       "cd53d3736715d62456a4d731a190d400961d2889253415f4e3866164eae76154"
    sha256 cellar: :any,                 big_sur:        "770a229629111ef6c86759c391628f165bf47124de45db721a9b26503911d95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32bac246c0b04d6d55398d17ab13fa6b3e03bd737ec198e2579d823d00090a64"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
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
