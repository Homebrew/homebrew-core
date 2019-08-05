class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.5.1.tar.gz"
  sha256 "817d33d59834f9a76af99f689339722fc1ec9f3c46c9a324665b91cb44d79ee8"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "c40a3026ad109c70170edd046719181193b11115909ef0afd82b23ff6fc91a89" => :mojave
    sha256 "095c3dacd022b3809757518b36d674e36c567deb9466876cf28725a1eb447464" => :high_sierra
    sha256 "71e79d0b58234f75de7f674be366c8faa702387ff900a1d93ecd36514a89d578" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
