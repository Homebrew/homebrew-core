class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/1.7.1.tar.gz"
  sha256 "e1e9993b1320c8623447304ae27031502569a1e37227ec48d4e21dae7db6eb66"
  license "MIT"
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "f6f251fdfc7a65889efe2b428ee6ccf9be62258d717a8e9cb9adb5fef7c0e93f"
    sha256 arm64_monterey: "2dcb7ed95b83914ae3c477e8272955224b51d34b906e6057fe3f667be66154fa"
    sha256 arm64_big_sur:  "01c674bc7a80ac4ffc7d91f3557bfd0056a36337285d90b3ccc4595b8e9c9a54"
    sha256 ventura:        "801da0da28dad4fb164565159342d3fdba5884e3b34c8fa6ad89dc244c2ac1b5"
    sha256 monterey:       "59f8a5afd097792730fe54ee3d71f92ae58e1a0baa87fac4d2faf3d58591fee3"
    sha256 big_sur:        "07d576a2efe91de00f31fc47c13c7396abc2cac37ea6501833b669ee6824457f"
    sha256 catalina:       "436a5cd144aadb451d4f0ec657d2b878ba3c4d1e239b18eed8cd78519937bd83"
    sha256 x86_64_linux:   "4ec0f91928dc35c61fbdcc509cc91a96584a54c00ef542f409884746b677efe0"
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
