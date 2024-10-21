class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.7.1/xrootd-5.7.1.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.7.1/xrootd-5.7.1.tar.gz"
  sha256 "c28c9dc0a2f5d0134e803981be8b1e8b1c9a6ec13b49f5fa3040889b439f4041"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "403f73ae745c6ca58af95e07a6a395112db4845d9e0c0df61f4d39142191f3c9"
    sha256 cellar: :any,                 arm64_sonoma:  "f6c5227ec3771af8ba6e75edafb0bff2d24ff869e4eeefb9c9926d28ae7ba5c1"
    sha256 cellar: :any,                 arm64_ventura: "8bd0bc91c0689c33cf17559d5a41a3ca42c2fd59cdfffecb453413da361272e5"
    sha256 cellar: :any,                 sonoma:        "9142fd66504f0eeea0b917d1f9b4af240d0a734c23ebe57842d8563afa3fc428"
    sha256 cellar: :any,                 ventura:       "6e628c57fcc5c83ca34357a9f7df797f4e6ba69128017910ee72fcb5e5e7209a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af90d3714eb102ecd095fa85784a6d0407a0bbef36b0b61874940f182a70f13"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    system python3, "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
