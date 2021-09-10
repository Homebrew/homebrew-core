class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.6.3.tar.gz"
  sha256 "1116419527edfe73717b71407fb6e06f46098fc8a8e6b0bb778c4c75dc9f64b9"
  license "MIT"
  revision 3
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "effc05a1dc99771d4f1862e8507a454af4591df53be2eaa7cdee3c4e62a18f1c"
    sha256 big_sur:       "27dcb4906faadbad0117389bc2cc634743d7f2287cd6f9a8a7379dd1a4e652e3"
    sha256 catalina:      "8774607c36974cc37ee765e925ea535dd51f33ab57fc134fb68ab45da4c70eef"
    sha256 mojave:        "fcf3fcc3945fe46b3a9478b7f8b42149af40e331bc793af6b8202bc8d98dbc5d"
    sha256 x86_64_linux:  "992223bf53b39c45f70bfa5940b16f8a0768ee311c969042900fca80607c7389"
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
