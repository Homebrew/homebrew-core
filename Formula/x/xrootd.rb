class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.9/xrootd-5.6.9.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.9/xrootd-5.6.9.tar.gz"
  sha256 "44196167fbcf030d113e3749dfdecab934c43ec15e38e77481e29aac191ca3a8"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f2f88e80512ee3e21678ecb799b4a2e2c09c9961cc14b9674fb8b9c1fa86929"
    sha256 cellar: :any,                 arm64_ventura:  "f58da072f0bd600f028798651b8ffbd85778dfb5c321daaf45c370a7df7f62ee"
    sha256 cellar: :any,                 arm64_monterey: "6d10aad4c678327f40d07802907da37a3e8c3721b8aff7af308cd9a60e3d6687"
    sha256 cellar: :any,                 sonoma:         "e7a2a72c88c5e49cfc6ce0ed6248418338a834b7336172ec8e0ce2d4b24645a0"
    sha256 cellar: :any,                 ventura:        "e1fa6b7efefb7d49925843af12e25a108fbc20a941026b39de17c4a8e76ef1ae"
    sha256 cellar: :any,                 monterey:       "982763601e02b82bd3e99eeb11a9d360602dd76db2776fd266763171cd6b57f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb073481a55b201d8746ae01638b35cf5ec9dbafd5e87b29a808148141b1f5e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPython_EXECUTABLE=#{which("python3.12")}
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
