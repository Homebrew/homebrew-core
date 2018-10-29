class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.8.3.tar.gz"
  sha256 "ddf0c273fcf71889989c971c2a27b81a05aa2352a4bc03481730576583de4696"

  bottle do
    cellar :any
    sha256 "972836a637782b6a91f7b8210b553686b70c9600ca560fb46068456f72aa41c4" => :mojave
    sha256 "74ccbba60b4e8f0ac0aa9f6f213721d489d0ed202af9586543fca93364a022cb" => :high_sierra
    sha256 "13c058cb692d9eb3d6e7fb27687196f4d1bd1ca77d73ba8c02404635119c352b" => :sierra
    sha256 "06507683d291d3e445e62c91747067fd48c1083ea4e92e02415b2544e1fa4948" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V", 2)
    test_server="donotexist.localhost:65535"
    timeout=10
    begin
      read, write = IO.pipe
      pid = fork do
        exec "#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
             "--threads=1", "--retries=1", "--url=#{test_server}", :out => write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
