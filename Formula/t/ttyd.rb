class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.3.tar.gz"
  sha256 "c9cf5eece52d27c5d728000f11315d36cb400c6948d1964a34a7eae74b454099"
  license "MIT"
  revision 1
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "69a099f652a4627ebd1883cf6f30ffaf24d10860f09ad70f165d1d325cef8df1"
    sha256 arm64_monterey: "904dc5cfb60de817fceadfe24656122a3afd9ec4aa7f9e66d7a6adfeb2da2b5c"
    sha256 arm64_big_sur:  "f59972a5107ab4f0db65881a886b6305d1c85cc7cabdc1c63c9019e059f58653"
    sha256 ventura:        "bf497b4d9a89b2a0fe3298e41b114aaf15745b30600a58867465c25a5c2690ad"
    sha256 monterey:       "714cce29332912b168fb7f3bb5c96c94804b88051d906bccc8d2008361e9497e"
    sha256 big_sur:        "4c565f05abbe15174806522d06bc5b764544c1c4cc5ab48d97ce886d4d5af108"
    sha256 x86_64_linux:   "3d8bc1f21cc6c9f0d94e3e74bcf60adb9be03f06dd7b49f5e2d16b4212b052c9"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-Dlibwebsockets_DIR=#{Formula["libwebsockets"].opt_lib}/cmake/libwebsockets",
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
