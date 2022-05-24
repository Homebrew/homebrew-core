class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  revision 6
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "524013d1679fd2515a40deb3960e3e867403ee80ed8492695bea46ba5efcc8fb"
    sha256 arm64_big_sur:  "d9fc0f9b87ff3a47188bd3b84b1ef6b5fc07028366631e03b2624165b76a1883"
    sha256 monterey:       "f462684eca351cbb766839e341a8740492ada7fdbb2d37dd2df10b11bd3d689e"
    sha256 big_sur:        "934bdd58fc7a75c85133e43b5a1d07f20469e3b23e85b04057c2f4c287afd238"
    sha256 catalina:       "5cbd30c58c342b491fe87f2324afe12e736b70eace5441422c594049369892e6"
    sha256 x86_64_linux:   "3cba3266866517c20b24f754d769882a461acd858db07e3c86c1fe797348f890"
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
