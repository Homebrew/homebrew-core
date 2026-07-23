class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.3.1.tar.gz"
  sha256 "51a5516ec5cb01823633b4d8cacdeee4efa0c56ef620d1c996d4f52ca51a601b"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5aa0861161f4e13c703825e23a3c885010d68a0f494c1af257929654dc3af9b6"
    sha256 cellar: :any,                 arm64_sequoia: "3752f8347e8768b3a6f6866b2c810367c4f6616ac7f2768e6697b7b8fcb0fffd"
    sha256 cellar: :any,                 arm64_sonoma:  "516c630dcc63639159d464b219c1a197558dcfd51fb76f470d0dd9d50e1a5c5d"
    sha256 cellar: :any,                 sonoma:        "6fa68b12118c439cda8382787c169945c638a70881aa1b4efccb277a9043748d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c6921906b1a5168ffb2ebb6bf2ee85bc391510420566cda8646cd778ef2782a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98c1400165331ac59969b19840ab324097188e3f79d9f0ee904463ea0724aad"
  end

  depends_on "libconfig"
  depends_on "libev"
  depends_on "pcre2"

  def install
    system "./configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port
    pid = spawn sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"

    fork do
      TCPServer.open(target_port) do |server|
        session = server.accept
        session.write "HTTP/1.1 200 OK\r\n\r\nHello world!"
        session.close
      end
    end

    sleep 1
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_equal "Hello world!", shell_output("curl -s http://localhost:#{listen_port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
