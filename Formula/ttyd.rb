class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    sha256 "a02e04e5aa70943d5998c5e75c49a82037725d205560391c89987cfdfb397472" => :big_sur
    sha256 "f7627069a2b82aa5a279fb5b3ac54ac4da377c1b26a70998d3ebd6822e0cf266" => :arm64_big_sur
    sha256 "c915f944862f3db3e74444db19a8df4e0f045f826877b1a1abad8f366c57b1a9" => :catalina
    sha256 "b3e8614d3b270121d85fae679016c68fe0f2c633d538dde1daa7887d1137cbeb" => :mojave
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
