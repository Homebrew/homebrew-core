class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  revision 2
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    sha256 arm64_big_sur: "3613c44348f2bbc54ee0a76bc09b99f5d1fcc0f4b207b7b6d7e5e69a60491600"
    sha256 big_sur:       "44d98800018b084ba70f64fe6cda1c4e7d0632dc6ccc1875ccd7f9f60d424634"
    sha256 catalina:      "fbc13a08d2e1193bba14db733744b92de148d5852d6f17c5c46a2776d1d469ad"
    sha256 mojave:        "930c22597fe1b35a010fa73baca293feb1311bee1f625b2bfe52b6ac0a5bba1a"
    sha256 x86_64_linux:  "3feae990ff47b0e9e4f7a14663557f2a6dadd89bed927def54c3db7d214024bf"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
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
