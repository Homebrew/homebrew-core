class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/refs/tags/v6.24.0.tar.gz"
  sha256 "3521c592a18ada781d79c919ea6c1b7e5a8bcfe2ec666789bc55fd88a2aee8d3"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48cd8a81cd2082dc4f23a93171c1046d704c7bb6c914d5edd2045de584f329ee"
    sha256 cellar: :any,                 arm64_sequoia: "f84460bc7617a39bbd1d1cc7f2fa93d0cdd692bd935ca313ff482fa81d8175da"
    sha256 cellar: :any,                 arm64_sonoma:  "76050f2e875de91d54caeb895b385f60a324515b359b314d2d0e303d5aa2d808"
    sha256 cellar: :any,                 arm64_ventura: "499692d0ece7d0207b23e6f11a77d55f4cd96e99a57ebe787ff995232753bf3e"
    sha256 cellar: :any,                 sonoma:        "523eedc13a5e34ca81d8ab372449b633af5945c827cd74b826feed152b2bc5d3"
    sha256 cellar: :any,                 ventura:       "496fb01300b5ac730090858b2ec0bcb680935262c04964b0b0c6a066ef22ab31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38467683be8b9ba68eab0fe01caa3a4fc03bcd4d758f4235d4002bae52f067c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5adb790b5d9a38b7348293fbce85964cee1396abfb68da54f18af699b88c1138"
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
