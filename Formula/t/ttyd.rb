class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 3
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3575c39d033473cf334f3ae01be1c9545f167e31897ccece1e64ec818fd2923f"
    sha256 arm64_sequoia: "286f33bd4f2d04694e70e27eec18b4d32ea7dcf8dbf609900b3d3391ec44eb50"
    sha256 arm64_sonoma:  "8871886dd83c2666e921d9891b5cf60ff3854efa699b19e8133add3fb2d80615"
    sha256 arm64_ventura: "134a716ab6694dd2fa944bef6149f89e4555c06c2f5acf7798538f2895b820fa"
    sha256 sonoma:        "aef24f3864a335abb92a577d7c7a7bd23a41c1f7ba590e15b52cd899f4cddb8d"
    sha256 ventura:       "d15c58a5b7f85a28266fba4eaff26f6a114996d07b965d7797bf07d18264b747"
    sha256 arm64_linux:   "c9f58aa81b52998f825007e7a1d36705d5ef45bca7bfaf992c26c459f07ada38"
    sha256 x86_64_linux:  "3e25ce41430844029173828faaeb06116e7fe6a4722b3053dabf180ccb07426c"
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
