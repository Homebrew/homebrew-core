class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.3.tar.gz"
  sha256 "6eed82895da1359538471cbcc82576c4a21a4c6854e1f125fc55215f7c51da52"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "588c8b1b66f6762c5d69b210f46a67e56957a9d48a0312748851ea2a763a9521" => :high_sierra
    sha256 "5f364fe5b7c1cc600ef3e6057a7e0f0def8c215c77813b85041437c7c68ed3e4" => :sierra
    sha256 "d0deb06e23d1631b4108698d7a82cbc1e84ecd7b49bdb48f5a1465ae3c99a5d7" => :el_capitan
    sha256 "1fc81d1d00261c259868b79161ec4cdca279522fbeae040ad9b572d88b2d71e1" => :yosemite
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
