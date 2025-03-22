class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.22.2.tar.gz"
  sha256 "34759ca9c1b2486ecb7b6bc267c76a6f365d401b2b6de6d667e0a13ae30882a2"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9a264f7ce1589c334422e779cb204da748a18420b2ab60e3e5c73185c9b158a"
    sha256 cellar: :any,                 arm64_sonoma:  "916d329c28225e91b58aed158b82fded68580cb78545e35615abfd5d59401cb2"
    sha256 cellar: :any,                 arm64_ventura: "0060b2c5f152029d5a92d1fc3f87c664d36f008b54f3243f92aaeae97fb8ad83"
    sha256 cellar: :any,                 sonoma:        "244f472b2bc2b2d888ee23900ae772ad2f5405955dc7c0743c96d9e43c4ca94d"
    sha256 cellar: :any,                 ventura:       "294047c602acc9cba226a26c6295ff6654837d1cc74e0e88b5f5e244e451df4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a24183e20464dd0eaaba0aac53cb8ebdf2c7301681aced582078425fe4fe43d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "528d692d91a98a92d56097d23d3ecc3f71e60a45b27ec20ed8ef0d1405a2070c"
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
