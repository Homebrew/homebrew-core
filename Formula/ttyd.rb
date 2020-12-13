class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.2.tar.gz"
  sha256 "fd3256099e1cc5c470220cbfbb3ab2c7fa1f92232c503f583556a8965aa83bac"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "92cd205e93b1b3d9f8c22c385b76f1a1aee69b84d6127870d58cad097b8e1e99" => :big_sur
    sha256 "97098f5b98c13ae80374fe41c1955ada4382449e3be7f08984b843c439be18b5" => :catalina
    sha256 "34d7eceee16997bd2ffdbba37951b706c9e0a5cbc27761e832be71af7c0b18c9" => :mojave
    sha256 "00276ef8a5190eb11920cacaa23d940f66032ab2267b19839531876097f38f64" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim"

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
