class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  stable do
    url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.4.tar.gz"
    sha256 "d0a8b600fe1b4eaaf6277530e3cfc8f15b8ce4035f16af4a5eb5d4b123640cdd"

    # Fix to cmake 4 compatibility
    # PR ref: https://github.com/Haivision/srt/pull/3167
    patch do
      url "https://github.com/Haivision/srt/commit/7962936829e016295e5c570539eb2520b326da4c.patch?full_index=1"
      sha256 "e4489630886bf8b26f63a23c8b1aec549f7280f07713ded07fce281e542725f7"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "023760d7f2e532bf14d215764aa8d64c2d4e52d6fd116d51f50252269813d5ba"
    sha256 cellar: :any,                 arm64_sequoia: "2c7b2c84e165de83ce32e46bb6263158c2c9e680b816032d5b6771ccc6f32d7d"
    sha256 cellar: :any,                 arm64_sonoma:  "8e8f3ee4f8fdeb10602feb2fac3d140e236df5024e212fb6b6f1455bf2061532"
    sha256 cellar: :any,                 arm64_ventura: "806fa132d70ecfff69e3cecb0f4c70d8e994293e748ca21b7c30290c09e7db05"
    sha256 cellar: :any,                 sonoma:        "a32f1c565c530f10c2a9e1d943d0eacac64b129ba745a2eb6da520d574bd798b"
    sha256 cellar: :any,                 ventura:       "0d2f45e1447a367914e64e12d4039f7488a6c9675a2d8206abe65d741e553f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d61f9d71831b4739cfc90208ccb2bc051e417e30f88ff91b131cd3a679be21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6e779a8068e881ea3977fd8ede3863b108f621589ee1f87a28360fd6d6ee257"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]

    args = %W[
      -DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}
      -DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}
      -DCMAKE_INSTALL_BINDIR=bin
      -DCMAKE_INSTALL_LIBDIR=lib
      -DCMAKE_INSTALL_INCLUDEDIR=include
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
