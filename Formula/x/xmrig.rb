class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://xmrig.com/"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.27.0.tar.gz"
  sha256 "4cf0895edae1e32042c8c0103c4a9d1fa3b3a0bf8a81ce7733ad6539514b48f0"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c57756f917ae62cec4ee2e1750a90d35b0af97497157f711c92240b8bbcb2c02"
    sha256 cellar: :any, arm64_golden_gate: "d7b0e0979d5724c65f87ac4fc6681188d637295ce18abccbef476c91abd647d6"
    sha256 cellar: :any, arm64_tahoe:       "6f7f6d658e7d44d02ae660c50b9726da9d8f416f3388d02357e6bd694294f9d5"
    sha256 cellar: :any, arm64_sequoia:     "dc7663cbff813e1d9f1969e6333a4863a012580e916964867d294d5aaf9c6936"
    sha256 cellar: :any, arm64_linux:       "313894b2704cfcc72382a6028f88c8fd7bcb7f6fda1d47e3bb9977d2dd490863"
    sha256 cellar: :any, x86_64_linux:      "f5256cc3e52e2fc7ed9b9db5566344af7601b24ad8825ee8cbeacd1665c66a6b"
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libuv"
  depends_on "openssl@4"

  allow_network_access! :test

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
