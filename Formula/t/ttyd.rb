class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://tsl0922.github.io/ttyd/"
  url "https://github.com/tsl0922/ttyd/archive/refs/tags/1.7.7.tar.gz"
  sha256 "039dd995229377caee919898b7bd54484accec3bba49c118e2d5cd6ec51e3650"
  license "MIT"
  revision 6
  head "https://github.com/tsl0922/ttyd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "06eddb6a32a7f40a0639f70361b93e63350b8e1b80db21517df23816b9c55439"
    sha256 arm64_sequoia: "41165f7d0cc31ad5c8ac833e0070041de3b055837d7946cce2066ce916dcea69"
    sha256 arm64_sonoma:  "7afbac63fc717144f6180820ea349ba8028683168542e019b6bfdc6bd2997e04"
    sha256 sonoma:        "55174b908654c53aab6a220fe3b1e8efd365f47d1c47a7b0a6e4d977017cc511"
    sha256 arm64_linux:   "2a612a1ccda5dbab4d0db6f4acf381815e25179e5bd69fbbf5766cb5fb6de20e"
    sha256 x86_64_linux:  "4705b5d8017f8761bda7a785b08f597fa7f84418265f7a6628266472fc2a8d1f"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "libwebsockets"
  depends_on "openssl@3"

  uses_from_macos "vim" # needed for xxd

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}")
    assert_match "<title>ttyd - Terminal</title>", output[..256]
  end
end
