class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.2.0.tar.gz"
  sha256 "00f8399a1045057a55a5a5dd2540bfbf39df972ad0c1c2a9e3bc94574514c9bd"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "cdc674a1a1df389bece0ebe01f4f6f7653ba4ae79a543bf38a97d45faec89ff2" => :sierra
    sha256 "7638dfb95fb6db77e3745110579085317f836d24ea84bb0450dd9f6d851ef931" => :el_capitan
    sha256 "edd2b9e1c5f1b3777cd3a1d0ca94c0522174a4b96232f6a1a1e996f0497f4d4f" => :yosemite
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
