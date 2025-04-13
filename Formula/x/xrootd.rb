class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.8.0/xrootd-5.8.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.8.0/xrootd-5.8.0.tar.gz"
  sha256 "fb5810e18670759292d22a3b5c92d21e1c301e999f319340fd84a6bc8ada6ca2"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "364971b10289c548796d864cd371ad3f400a953f7cdf16275cfde370ff8e42ec"
    sha256 cellar: :any,                 arm64_sonoma:  "995f10ab672ec44a952cc129fc9c1bc37a6cff892de5f46bcd98a9c36492a09d"
    sha256 cellar: :any,                 arm64_ventura: "89a1ae63a388c24fe524290b240582d3842fe7ecfaa2b30d6006548060dfb214"
    sha256 cellar: :any,                 sonoma:        "e94a39e34a83bd400a31f274c1853ddb8b241ecfd2a2f43844f0c5e5d797d604"
    sha256 cellar: :any,                 ventura:       "46c5ba28d89d4055d2e0bb18b4c744f62196a3ced31f43f3e3b36226b5ca52f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e76d82a608c3d6f66f5f7bd967dd3a8966c009b24d52df4344e70c88c003831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1caae88e954b6357779baa51fcc11cd1084d46be765f6637d3f67a059f4244f1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def python3
    "python3.13"
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
      -DPython_EXECUTABLE=#{which(python3)}
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
    assert_match version.to_s, shell_output("#{bin}/xrootd -v 2>&1")

    system python3, "-c", <<~PYTHON
      import XRootD
      from XRootD import client
    PYTHON
  end
end
