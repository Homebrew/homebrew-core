class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.19.3.tar.gz"
  sha256 "8c7e48690c8e0f6cbc22c2ad2093328152e34208d1c33dc24008dfcab22ea3eb"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e13f2431e0abafdcb5f1dea78d34a7f7cfc82eed46a0ce9b54bc54dd3a74310c"
    sha256 cellar: :any,                 arm64_monterey: "8a43e0bcbb34415d2259e5218ebeadfdea52aa3322eca61efd06407dd3d29d32"
    sha256 cellar: :any,                 arm64_big_sur:  "228a6e02fc6061e70b2f3401d8f584c056b4274745a358f019d978a46c30a094"
    sha256 cellar: :any,                 ventura:        "1a90caadf434593c23ec41b122999cbde443f76e7bd481dce7cb26e6dfe00483"
    sha256 cellar: :any,                 monterey:       "a5936c7c8694a0fd3bf764e2585c468dc8d7c74a08b823b1d2eda3926be94ba5"
    sha256 cellar: :any,                 big_sur:        "687adf3ac0f15e0ea3641742aa47614f4f8a1cc4adb10e8c4d2d7a4fe5c17afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d45c311fe77f028713698aa2f847bbabdceda05ddad6246ba763715ea24822c"
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    # Use shared OpenSSL on macOS. In cmake/OpenSSL.cmake:
    # elseif (APPLE)
    #   set(OPENSSL_USE_STATIC_LIBS TRUE)
    # endif()
    inreplace "cmake/OpenSSL.cmake", "OPENSSL_USE_STATIC_LIBS TRUE", "OPENSSL_USE_STATIC_LIBS FALSE"

    # Allow using shared libuv. In cmake/FindUV.cmake:
    # find_library(UV_LIBRARY NAMES libuv.a uv libuv ...)
    inreplace "cmake/FindUV.cmake", "libuv.a", ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/xmrig"
    pkgshare.install "src/config.json"
  end

  test do
    require "pty"
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server = "donotexist.localhost:65535"
    output = ""
    args = %W[
      --no-color
      --max-cpu-usage=1
      --print-time=1
      --threads=1
      --retries=1
      --url=#{test_server}
    ]
    PTY.spawn(bin/"xmrig", *args) do |r, _w, pid|
      sleep 5
      Process.kill("SIGINT", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match(/POOL #1\s+#{Regexp.escape(test_server)} algo auto/, output)

    if OS.mac?
      assert_match "#{test_server} DNS error: \"unknown node or service\"", output
    else
      assert_match "#{test_server} 127.0.0.1 connect error: \"connection refused\"", output
    end
  end
end
