class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.22.0.tar.gz"
  sha256 "8a5b047cbbb67e508fd5c2cfb75e138d36b1eb19aaadcbe59a5034ca9af0ebb0"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "27d0f6fb789504cd2f216e5e90def793af7150333e61180ca255599d942fb2f3"
    sha256 cellar: :any,                 arm64_sonoma:   "edd0b049a3afa8a78f85eb82ab06c9cbf0f89fd10e1f7f540e1b492a31eed33a"
    sha256 cellar: :any,                 arm64_ventura:  "87c40602af0dd95350df0c885450d0ea025a78cf874578c91d3f2b4069aa1136"
    sha256 cellar: :any,                 arm64_monterey: "356a15cc0f5a411aaf2672c5929da18abab1cb2a854e34b3688495f3ed8d06e2"
    sha256 cellar: :any,                 sonoma:         "28f8d520663634784ab2d9f02fac8b0086388c9db0c2103fb22ebd6fc550760a"
    sha256 cellar: :any,                 ventura:        "4fdc148d529141755f516e941df2bb9a0db28aa345029444c551cb676cc7c48c"
    sha256 cellar: :any,                 monterey:       "dcf29d82456b49be131f62511659ad3de7003b7eab9292d2ebd7c43ec36b831b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f365ac3515b8821c8dd22a415ea1e4e5802bf9af8e368c8668c01662b82c80f"
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
