class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.0.0/xrootd-6.0.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v6.0.0/xrootd-6.0.0.tar.gz"
  sha256 "bc8d00b6c0b48f9186e3ad09e8e4e6eedf1067fad68f6d6a4f4e939bcf87007c"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bea56759270c77ebc33d0e108a570d274a153cad2d593fbc6c06f2cc48de4c8b"
    sha256 cellar: :any,                 arm64_sequoia: "7c82206f58a10dd6a45db0c374551ace5576fd78373f0e451110267ab9a6aba6"
    sha256 cellar: :any,                 arm64_sonoma:  "56e36426032e8d3c1b654a629124c3d48cb2b9fc4ea2410d1750959b2016ccd9"
    sha256 cellar: :any,                 sonoma:        "500ede15a4bbc8aaebf23b7bedc73e1c18e3f06f4c5a5250b2bc606f8259f4aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c0b41a34676d902b0135a0cea811c12cbb5ae369aa227d7d3a4beb4904917f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa893509ccb40dc14c9ace235c61e615e1ce0c9c85a8bcc0f2cf49fcf778bc6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "libzip"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
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
