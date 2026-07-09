class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "c3518bc43a71b5289032395b2db4c3e09e73d78b54247d56c14553a503b491cf"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/Haivision/srt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f201e850fa33ee027f7e8360ab55474461c6d20c996ed261bf9d17198a9d0e85"
    sha256 cellar: :any,                 arm64_sequoia: "fc5bbd1fed835b6bbcb15cb62c7297e137ae526250c5ca1b21dc6b4979ed22e2"
    sha256 cellar: :any,                 arm64_sonoma:  "b69a133af8ac9cf43a298423cd4b08614395b36c0df3c9b7e1ade63b9587a304"
    sha256 cellar: :any,                 sonoma:        "be1c49b063c22ff0edf2a822e09585ec85649a7845dcd770681217659655ca2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4daed54a610f9835b41b63d5dd16027e2d1dfd879aea01c1fc85d65d38a61ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d7d47c199ff8c9e1e6de7b409dc3a81c6573f49be3b02bb37aacdb335a6b623"
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
