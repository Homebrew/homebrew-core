class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.org/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.2.1/xrootd-6.2.1.tar.gz"
  sha256 "43b974c4d2afb6a37687c2d81f0e61c1213fa46470c1da4b2b58e5d6319a6f26"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59fc826afe2223aaaa7f032b09e47bc8e2767948c5b61cc7954d539c0745f015"
    sha256 cellar: :any, arm64_tahoe:       "ff9f3fd7d0afa3b37a17b6d4bb0a68038bc59b9ae309f715b90bc10dff9c5679"
    sha256 cellar: :any, arm64_sequoia:     "01530b42e1f89e7426c81be37629f5f89bf2cecb2fd5941cca498145c5d8933b"
    sha256 cellar: :any, arm64_linux:       "03f3a3448d060b9c48d2c0d44c6b126627d0930f6378631c7b636495c8020f59"
    sha256 cellar: :any, x86_64_linux:      "6275dfbe2fa76a49e7d48a57cd96e654063100a5d56936321ad622741b6396a9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "libzip"
  depends_on "openssl@4"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPython_EXECUTABLE=#{python3}
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
