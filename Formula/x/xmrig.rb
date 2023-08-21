class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.20.0.tar.gz"
  sha256 "86c62eb6db83981b21ac1faac69c28fee2952cbbc207ea7476707d4f1799633f"
  license "GPL-3.0-or-later"
  head "https://github.com/xmrig/xmrig.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4ee30ef215e315ffd3f10091ec17cd26bed3f8b55e92013cd4ae39881f605d7"
    sha256 cellar: :any,                 arm64_monterey: "d972fcd5fbf5f99f30f9516aa761f2e6f2d2f9285a7cf5c618edf5f08dd5b19a"
    sha256 cellar: :any,                 arm64_big_sur:  "3878a1e5f63c6401353eab8f98667fdc8ad4a4f316eec339f5b3e427e068730b"
    sha256 cellar: :any,                 ventura:        "44e2127f8956286847d68052bde394d84cc759c32213d194972c4fe2b1c54be8"
    sha256 cellar: :any,                 monterey:       "c3c041f8f73d606068ab821d6c2a950a74792c1602a4b3cb50cacb75fd2f27da"
    sha256 cellar: :any,                 big_sur:        "44ffbb9e76ace43ab79593b8574d6e627a9e2d3b1606b5259a9ce3ba6e9789d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "934d02c4376d1c1dd7d7919c0a873ca6468a46f6230d8e32bcf921239f528b11"
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
