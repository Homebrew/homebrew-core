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
    sha256 cellar: :any,                 arm64_sonoma:   "d0d12851699cdd8842512bc872e9545c2f659f42a8b4220667bcfcd5464d54c5"
    sha256 cellar: :any,                 arm64_ventura:  "cd359ff13c041aad55875645e217e0e9f8d3d1811eb574ccee45e6b31e0ac884"
    sha256 cellar: :any,                 arm64_monterey: "738a0d421fdea10cbbde7e7992b9a111836cc0ef384f0c3e5693938482eedf9a"
    sha256 cellar: :any,                 sonoma:         "ee518cd4a5f76d04cbb8a80a9372083ff2451491246317f387490fcb5a6bab07"
    sha256 cellar: :any,                 ventura:        "b2cd1ce823988c6de31319dc1e81b1bcb723085efaec95ac92242733f5e1c05a"
    sha256 cellar: :any,                 monterey:       "78524a6c4088a970c5c2670c6b9d3d025afba6b6e665796b110b9163f4097cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3beab79a3735f67099e1611ca98c9d86955a0b045331231fad1f0f3eed5bf9a"
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
