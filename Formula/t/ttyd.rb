class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.4.tar.gz"
  sha256 "300d8cef4b0b32b0ec30d7bf4d3721a5d180e22607f9467a95ab7b6d9652ca9b"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "c9adbdd1216b21fccbb48c99710476e3a775ae674fa7ab9917bcf460c87b4756"
    sha256 arm64_ventura:  "14e4f30ed9d013899611d906d9763d9d69063789395d7cce1bbb51a11b643956"
    sha256 arm64_monterey: "0223ca1acdd9631e08afdf6527b34b1cea5f16af32b96cea9e03d3035118e090"
    sha256 sonoma:         "c757a2bf373d1734ec14eb11140df2ba9eff849af8f9c727b2385b4290eb6313"
    sha256 ventura:        "c2ad72104df43b4988adcbe6eaaa74fb2ced88c96aa428c5fd3faff04d14a0ba"
    sha256 monterey:       "959512318be4738c518d62f7113a111f3c49329e7e55b6e6aabc618a9c0e838c"
    sha256 x86_64_linux:   "351b9e02f3a2083a20b29002d114a398e223d1581d30a7859e0846690060025c"
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
