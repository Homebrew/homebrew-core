class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.3.tar.gz"
  sha256 "c9cf5eece52d27c5d728000f11315d36cb400c6948d1964a34a7eae74b454099"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "8b199b80e2db8ae75ddec34665c07134c1fc3487df5275e9e3e740ff4a2ceb35"
    sha256 arm64_monterey: "2a9cbc3bba5e612ff8f2f4564a659c7a2ec76c1df1988c472f908586e6bb2059"
    sha256 arm64_big_sur:  "26320ea78fe2b96fa84d452e74644eb9df9c7545ea745d80040cfd25395a644f"
    sha256 ventura:        "c0a1c794c66becb0b24637044ea58cf12cc1bb7b1e2b925dc48eb0ae9c83bc58"
    sha256 monterey:       "fc3d88893904af9739fff016ce6a94122b48b4b8c736b82d2d0a92b7f2bf83ee"
    sha256 big_sur:        "dad92d87e557361d39a8321f4eac0f2e980d1105ba0f1f4ed03807857ba5efa2"
    sha256 x86_64_linux:   "86ca4903c3b638cd20e8aaff667409dc7429f4bab507c688d413834e6a1a9926"
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
