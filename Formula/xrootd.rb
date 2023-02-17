class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.5.3/xrootd-5.5.3.tar.gz"
  sha256 "703829c2460204bd3c7ba8eaa23911c3c9a310f6d436211ba0af487ef7f6a980"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56dd037997378e68148a366deedca6c310163e62baf2e474e1e516a1fc9dcb77"
    sha256 cellar: :any,                 arm64_monterey: "f7f7ede271ab38f3357bc3525e09f9f5358e862ce71d23ecf827a402e65563a4"
    sha256 cellar: :any,                 arm64_big_sur:  "583f54092976ad9e0bfd6645af0fad6a19bef2fabc3075bed5053b1082658081"
    sha256 cellar: :any,                 ventura:        "5c741b06e23762186202183376c4e9ab5ad316cbf9a73808579c7f84df36d1a0"
    sha256 cellar: :any,                 monterey:       "21adcc31e4ff9abf5317cc1b96124d3c16c925ee30e22afdde5b9b4c75c1451e"
    sha256 cellar: :any,                 big_sur:        "3dec53c1a4355f269b9072d6a57f7602b386d25661227bd0d10907039f87b0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700bc4b4c8763159d33e0576b778c4c3dff2e5f5d8d23c805d1947a8577efcb2"
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
