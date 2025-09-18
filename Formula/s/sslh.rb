class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.3.0.tar.gz"
  sha256 "09e9b572ca1e7fe2ccfb0de2bcfbc316638a8d82b86fedd253ddf81392e8fd38"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7df8cb7c01a4de44f8ee62c9d092b3e3c3835a3b810b8ed717ba8d68a2882783"
    sha256 cellar: :any,                 arm64_sequoia: "31f58a5a03884b485c70d3a4bdf8c4fe9dd1f8ca0cebe84c9450607cfc7b2359"
    sha256 cellar: :any,                 arm64_sonoma:  "4b88089a1a7b6f21ec8b414696095c5d292e2e8b87e57dfbc9f97f1c934aa0a4"
    sha256 cellar: :any,                 arm64_ventura: "cef60eec5b2e23041a5bb9fbcf9c547939f961ca58d35c26e3d4efbd4655b67b"
    sha256 cellar: :any,                 sonoma:        "8139dd460e96d6ea0debe37bcfe1f705919f8af3b33b117f6b4aed0f7254444c"
    sha256 cellar: :any,                 ventura:       "b0245947ad24d37ca320e6a78c994762f40d3e24a9c7f9a3fc0ff84a4cdaa4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580ee6f15217675399f09811c3d88aedb764707e96d1b2f7ae6d14eaa5cb9b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329b63887f6a1fcd2c9f35bdbde9e3e4c77dcc38d57d6e0b3d916c47da400070"
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
