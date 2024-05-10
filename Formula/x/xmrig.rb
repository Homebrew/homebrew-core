class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.21.3.tar.gz"
  sha256 "5d76fb19190956c564b405119315bc93db4ed8062b251d5e96bed70c5fa8033c"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "deabf346b702c5b7508b63c7c457d590ae30d87cad77178490968a8be53011dc"
    sha256 cellar: :any,                 arm64_ventura:  "e703870440fa3f9fec988cb19762fd2d8a63de44fde8ff21e7b9fb029e928724"
    sha256 cellar: :any,                 arm64_monterey: "f6e9bd9883639d2efb5b323a5ad01479ca76c991aa383aa0c04a155cb42f329c"
    sha256 cellar: :any,                 sonoma:         "6279353aae0886138b8bada64dce12d4855ce347c591cb9a8ae3303a42d8ff1b"
    sha256 cellar: :any,                 ventura:        "8a7cd63adb738eb47a915f6783a531234e2f9fe820bf90e1a0b7dbb97e50d707"
    sha256 cellar: :any,                 monterey:       "b123122286d4dd5fedb7977628d66f18a34b3b4825f88328f1bdeeee9a73ed0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4629e96fc4d478e5608e67f270002ea1529ddd2b58a7a0b6ae3378f014d8bf"
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
