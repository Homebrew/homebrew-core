class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.3.tar.gz"
  sha256 "c9cf5eece52d27c5d728000f11315d36cb400c6948d1964a34a7eae74b454099"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "b4f9740818d69e41a35a26233290abd771d1093ec2cda41dee78d174afb31038"
    sha256 arm64_monterey: "ffa65f4ebe4a27b8f781f044dbd72bd294aec8c2723ba7ebdddf42690ef00e32"
    sha256 arm64_big_sur:  "7fd6164be905fc020a2054f1c5386aed7e9e24580ceb3991a9e5883ecfd583a4"
    sha256 ventura:        "77a5f534497069a54b8b94cc38be9d42d8a432131c0ba19d8c028737f98f9377"
    sha256 monterey:       "8d87994089f7aa6c4a9c637bc0540bdbef9c437b9907e513a62a92ae67d4879a"
    sha256 big_sur:        "9ca6a7cdc67a97ccee1b2e06d817de057a1310506c1994cc94ea58e93a6344a1"
    sha256 x86_64_linux:   "2e658bf16dcefb9c1fc3b8c0ef863d231d209aba04e060991219bed0798a36be"
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
