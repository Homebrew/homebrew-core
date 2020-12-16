class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.2.tar.gz"
  sha256 "fd3256099e1cc5c470220cbfbb3ab2c7fa1f92232c503f583556a8965aa83bac"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    sha256 "070cd417fdfbe73bc6101add7d9445025b62d81f8c7b2600072c9633b03021ff" => :big_sur
    sha256 "741051ccab136e91ebd5c92a5d8ffdf1e187f3e00b9c3ee129d784fb0f2661f8" => :catalina
    sha256 "9dca324813646032f57df7a45d50af35f656ce42e8d37c63ad9d81f297511481" => :mojave
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
