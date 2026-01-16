class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 6
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "feb7342f18d4a06b41572151f929940feda53dccd67c96c6bae6dae31d0185fb"
    sha256 arm64_sequoia: "a799d5922af9614ebad142e35c65587e05d71d51728de254e1b5af344bd22fca"
    sha256 arm64_sonoma:  "bc0fd1559a12c5865ac450587838d5a270e74351e6812d4ae5c07f543784f618"
    sha256 sonoma:        "9bd353f6a7004259e77484df80ecc015b33ca66d8d2fa7a8edcba47ae45d4c2f"
    sha256 arm64_linux:   "c2868a264f813c57bc0bf5969671346ca63f8d923f2338c6ef65e0913242f78a"
    sha256 x86_64_linux:  "f6feba2fc94869ffdffc0773a4fd08d2d61759b525a953be0db6f75797accf57"
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
