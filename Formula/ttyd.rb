class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.1.tar.gz"
  sha256 "7133704cab2a5fbc187d96511fad87c00e220ae8ed6cb83220d39205cb928070"
  revision 2
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "25845bfd296c1aee59fe2ef7ac4b3c3408ccabfe3316f74042a3767ad671f281" => :sierra
    sha256 "62e9b71573851c0ff84e6ffc16bb75441154fd2f3cf8a64a6353d7a71601c45f" => :el_capitan
    sha256 "dc53975553e2aef603dcb064d6f227f74d385f5a108bc13a7c17885d456c4356" => :yosemite
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
