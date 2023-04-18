class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.19.2.tar.gz"
  sha256 "84b7d1cc0bb818d471d47a5e663839ae8ba8b8a3b641e227b03903125446e12c"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b994a4bcc04f7309bea30bb6ca72d7d0f534a2f6d84720475d17a37097cbaf44"
    sha256 cellar: :any,                 arm64_monterey: "5efaa6fcf2b619e5cd581c945abc91ebe94a5ad6c194fc341d89e71706b979e8"
    sha256 cellar: :any,                 arm64_big_sur:  "95fe3233a324020543df2230620a047d032016740af89e752990b6118041c282"
    sha256 cellar: :any,                 ventura:        "c76500afda52b2c6b7fe9362ad0f81c4db2eddfd2dc9361050b6d888129cdb09"
    sha256 cellar: :any,                 monterey:       "3ce8658db29a71c4ec68d3a9d103f81d8b4510a323b16a6b02937919665df158"
    sha256 cellar: :any,                 big_sur:        "23ccd266c2c645f9dc9c37bd03b0eb778028a78b906a67ad18c8e7053c1fbf30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa50d527b1ac0d9cc014c2003c57805bc8d44830e2cc8781744d66511db41d14"
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
