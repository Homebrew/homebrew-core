class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.26.0.tar.gz"
  sha256 "5005144e78571f26586410c2b2ede2b0c72afe22f97f1708ea24cfb253c3939b"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "692f6ffb157058a5aaa59129c0d89bc74092c983c3b6b3a01af358f6727feb2f"
    sha256 cellar: :any,                 arm64_sequoia: "42d39fb1d004624f28b37d5b4b8c83346872bbdb6e3b377b4fcead6a1392d5f3"
    sha256 cellar: :any,                 arm64_sonoma:  "f5cd258c8fb7cba3df39ee774010fc39a6eb3942a6f57e3e42aa19da9929aeb0"
    sha256 cellar: :any,                 sonoma:        "174150b95684a5c1028b8e357b1ee237bd6a8f05fe0449272ced4890b052661d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "739a3ddf564aa207c96c05746aeed50a8b7dd9497adf9572e044984f2d5d52b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb396eb41ae6942456d4aacef16ae8d0fb7a3e3b348e6406ec36f2cdd3dc8205"
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
