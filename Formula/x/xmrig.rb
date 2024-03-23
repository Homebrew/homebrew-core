class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.21.2.tar.gz"
  sha256 "68b4be51e99687bad15d5bf4ac9eed79a080ba89141f7363457a957ce9304e4d"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a89d18ccbbe7f7ab5291066cfcb5bd523661291fd6356b71a07d18dbdeb4e255"
    sha256 cellar: :any,                 arm64_ventura:  "48b070ac59ddd57dafa88e1c49756665a0f6b886c798f0e095f55db7528ce9c2"
    sha256 cellar: :any,                 arm64_monterey: "5944b251b9192871a7ec4a594c19a6f6ee2af3e3125895aed34c8505a7b9a1ff"
    sha256 cellar: :any,                 sonoma:         "3715614a4ce600ae92b5387066901b449ba83b2869f079832fa45663e82f937b"
    sha256 cellar: :any,                 ventura:        "365e9a4070be1bc07c1665a1bf7e298d098c3a58107a10852cb0e19ac500112b"
    sha256 cellar: :any,                 monterey:       "e07e3dd42bb6c43efc9cc2855a3bd6b705a65240c852734d9d7fe9bb036ac0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4aaa8e1efdceff5fe14d3990baf785b524bbef5ebfb8d86490ebffb57002cd"
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
