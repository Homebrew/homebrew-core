class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.4.tar.gz"
  sha256 "300d8cef4b0b32b0ec30d7bf4d3721a5d180e22607f9467a95ab7b6d9652ca9b"
  license "MIT"
  revision 1
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "5d5221d4830ab1585b19ead0094fbd0b4adf6134e0e655bbcedd0d24a71941fe"
    sha256 arm64_ventura:  "54f68485bf4f3fc31008f9c80a716ee3be563b1875546aa195644935cc44c4c3"
    sha256 arm64_monterey: "c66409ac053addfc2dc70858bb280c847fb317b3d2aaaa9c10530eca45621e28"
    sha256 sonoma:         "0ca301788b35fc26ae6ccea0610a0759dbfb3f8032bbec71932d62fce3a15684"
    sha256 ventura:        "de3d1bc7284cdc5c6b16d002c4da881383ec2f689bfd98dc14da9b48db2ea4a0"
    sha256 monterey:       "baddb6a95956d40d190cbebcbbc9fdb547340f5689d262f396b5ba3b99e322f6"
    sha256 x86_64_linux:   "bc55fd06cd64449931dcb4a9ad3908e9fa3ee7ec09a360b2fad6bc123f204a6c"
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
