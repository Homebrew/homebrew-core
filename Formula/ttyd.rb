class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.7.0.tar.gz"
  sha256 "47bc98d43cf2060af06378a2113605b229c46895a391613bdaa5a1197bfe5d47"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "50f0a502423c4be3790aa739aab8629089ae3d8c648f0e01e4aeadcb52fac642"
    sha256 arm64_big_sur:  "5bc1b6ab2eb1841427ef87649de81dfc880057688769853ff19a7060b50b869a"
    sha256 monterey:       "1c6efee557767b584306f08d07a9957dc41541d420c39acc0fcabdfa4b4563b0"
    sha256 big_sur:        "aabd68bbfc2cfbce4c0abd043fcd39f6962e4140f3e1c492a764b489725de79a"
    sha256 catalina:       "34d9538ae25a6801d9defe7188f73d9bac8ce0d4aef414034944c6c69cd00267"
    sha256 x86_64_linux:   "559f22bf5297c90e2e6d60c4c6880885a54bc5f84230fd922c95ff60e51cc255"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib/"cmake/libwebsockets"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    fork do
      system "#{bin}/ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http://localhost:#{port}"
  end
end
