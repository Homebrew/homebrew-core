class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 2
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "33c65b152fb70d584888f5239b8003090d15c828b034ae4fae6bc36337ad030c"
    sha256 arm64_sonoma:  "6d3eb5c3f4c049f7bce60349dc0c7b31df9336feea2b88c6cd8fb58f0b1c6057"
    sha256 arm64_ventura: "36a2735751c4de95d01299f4378f7cf000e560e80b0fc9101e35ff006bfb92e4"
    sha256 sonoma:        "6905f5957460561162dfd04a039cfa1d7792acc7de68154a432acf93e88d9358"
    sha256 ventura:       "6cbcd6bdda77c96268ac6e25c194037af3f054fd6a0b8a1b2614e6f6dd3675fa"
    sha256 arm64_linux:   "50912f458f5dd30ee4c08a9215285e84a736d0a4439cbbfcb590d17fc62561e2"
    sha256 x86_64_linux:  "7bddc259bdafc9182b5f33d160aca7d9b010782e0c9a69421ac873f1f0a6542c"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd
  uses_from_macos "zlib"

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
      system bin/"ttyd", "--port", port.to_s, "bash"
    end
    sleep 5

    system "curl", "-sI", "http://localhost:#{port}"
  end
end
