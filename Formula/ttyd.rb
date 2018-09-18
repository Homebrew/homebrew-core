class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.2.tar.gz"
  sha256 "ff1a66b418df6cd741868a8ea84f69cd63f15e52e3fa117641ec57d3c37a1315"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "b1829acbdc4bec9917e837e2800480c48da5988f56c016481b42c338084a82c5" => :mojave
    sha256 "28dda203aabd87961d0a9413d0f236235c464fa709e313862247f6c2bf9ebd20" => :high_sierra
    sha256 "e8d50fd876c89a417e815506a3a3e08673c145d3d33a8fedc54d01cfc3928ac9" => :sierra
    sha256 "02a707935652bfcdd92adeb0db5a2bcee70657c0a3049f72c32d83520cc6df45" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
