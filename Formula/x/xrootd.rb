class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.8.1/xrootd-5.8.1.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.8.1/xrootd-5.8.1.tar.gz"
  sha256 "d4878b01f82982005da50789051901fabdffe3a44404e889ebbd7138f58f9699"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a43553c33e58fc52e0287bf349bab140d088436dc5acd9d7bda2c40d3e878368"
    sha256 cellar: :any,                 arm64_sonoma:  "04d7c459b853b69c8b116f5ee1f395e066c7496b8bf94f7586bb258054d2e794"
    sha256 cellar: :any,                 arm64_ventura: "c8889bcd086f58100c2c09f10a8c609dc2ad204dce281feea3d46df5ca3fa0d5"
    sha256 cellar: :any,                 sonoma:        "78ba380d5097c54aca42f32886ffedb32a44b5b1528fc4c7b313e35da7365ceb"
    sha256 cellar: :any,                 ventura:       "c97163aa0557c783fc5eaa2fe57a6d35b0253c680f6ccc603e3694d7d8ff0bc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fad9f9381aefe6341a1fb717c63ade1bc6e73075345f665f7c8087d6c1f44e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72be23cd83f9509f17d50a8e455d32db30651a9750cfc55e36725953d0abc061"
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
