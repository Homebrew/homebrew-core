class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.3/xrootd-5.6.3.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.3/xrootd-5.6.3.tar.gz"
  sha256 "72000835497f6337c3c6a13c6d39a51fa6a5f3a1ccd34214f2d92f7d47cc6b6c"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9769c1f19b848014d30a897a39a66c3e03e4f4fed104ca58d133fc60381fc62"
    sha256 cellar: :any,                 arm64_ventura:  "d3799d744994d810eb779b4dfadbc0a378380aaeda303aff8935ececa1e9d8e3"
    sha256 cellar: :any,                 arm64_monterey: "1eed371a2a442c0fa6757fdb604263a7d68d818541b2860bbcfe3c120999278c"
    sha256 cellar: :any,                 sonoma:         "c51e4edcfde9c6335ea927eba79819d1796fd2c9b9b614b4a16c3e0899b50f1c"
    sha256 cellar: :any,                 ventura:        "5a80b1197bfe29ff98ce2be7f8ef323ae0a100606f3a227c8f1bb76a95e8aaf0"
    sha256 cellar: :any,                 monterey:       "becc6582c4201dca371139f4232db8f79d73f0af016790eff569da84de599cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86332d1b1ea3067b112ce34b1ca85f6ac290a9c4bb3de636d7d9031315b84ed8"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "util-linux" # for libuuid

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
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
    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
