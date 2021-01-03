class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    sha256 "070cd417fdfbe73bc6101add7d9445025b62d81f8c7b2600072c9633b03021ff" => :big_sur
    sha256 "ef35be33b6579c74b3adf4bd8ea146acee30b70911ae0daa4185b2160bf00d68" => :arm64_big_sur
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
