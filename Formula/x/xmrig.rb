class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.25.0.tar.gz"
  sha256 "55e415792f2a4ef2430cb26829b0b7d96fc52f51c6274831e9fe76b8aef28593"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9604cc30b8387b696667289ce0d89e11ff57c44d10ffa29a87757285a9654584"
    sha256 cellar: :any,                 arm64_sequoia: "51755d757250f44b8ff86969b9abedb853c593dbb61449df72534bc32f2bcedb"
    sha256 cellar: :any,                 arm64_sonoma:  "9292e360ce8f9b8cddf3d22e151924261dd7a79060918d0b5727e7b61d554a42"
    sha256 cellar: :any,                 sonoma:        "e098c8fa67fc8fa9a2f54b411795c53f2b04e9d71792f0b3c3f6cb6457102396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa7f0666bed45832e1ac91af84970d5bb809d8b8ebabdf735c5f60d2e12cafef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67943ff1e12e6ec9764fac9635dc284f02fd28fbce671fc896d82992d48272df"
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

    match = output.match? "#{test_server} DNS error: \"unknown node or service\""
    match ||= output.match?(/#{Regexp.escape(test_server)} (?:::1|127\.0\.0\.1) connect error: "connection refused"/)
    assert match, "Expected error message not found in output"
  end
end
