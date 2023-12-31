class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.4/xrootd-5.6.4.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.4/xrootd-5.6.4.tar.gz"
  sha256 "52f041ab2eaa4bf7c6087a7246c3d5f90fbab0b0622b57c018b65f60bf677fad"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "362263343208ee99430e6d49acb60429f692441c00b9fbf67fc728b3a4cf41c8"
    sha256 cellar: :any,                 arm64_ventura:  "b61472dff2404d0e35b9a3a9f6ab19615e7daad30ec82e73ea951ed6d3cabf73"
    sha256 cellar: :any,                 arm64_monterey: "4ce54a19a63963d027965fe46492067b18499a9c2786affa6d5726634c4f032f"
    sha256 cellar: :any,                 sonoma:         "61ba9394cb2b31edf158dfebb9877537430cbc6eabcc9eb08472868685ef5d19"
    sha256 cellar: :any,                 ventura:        "581d41e8a3347fb85019459361bac14a2c950404804599eab59b560dec273969"
    sha256 cellar: :any,                 monterey:       "f53cc97eaeefbc3dcf473f2d010976224eb277705c0ce7987ace45c039f6308b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65c161093352e60a28d560430ac781833dc8c4ef8fcc6a84813fede5b798db1"
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
