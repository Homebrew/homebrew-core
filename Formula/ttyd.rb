class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.2.tar.gz"
  sha256 "ff1a66b418df6cd741868a8ea84f69cd63f15e52e3fa117641ec57d3c37a1315"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "a43dd374f6b62d64e41b869b30657b9b823c81fbffefdc67ead877bcec15f2b1" => :mojave
    sha256 "4985fdd0d5d2ac07bb33733b34aceefaa0dc5cb5ae1195a01414679782d3c663" => :high_sierra
    sha256 "5f33c79299fdd719ac076a067733a45aa15793e59a1ebf761cb5fd55cd2424d2" => :sierra
    sha256 "999e8c8645e1d053802f376819d09846445749673ba60bc1450b6b8ea9b9b4e1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
