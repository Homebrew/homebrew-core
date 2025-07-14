class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.2.4.tar.gz"
  sha256 "696edac467111d0c1353a4ff32ed8dfa33bc914036644c69a7b9506b7ee49115"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  revision 1
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e33d422b1f3f1d783ee9eeec9cd64c42cd6e0d06c362637f1bfc7f537d5f2814"
    sha256 cellar: :any,                 arm64_sonoma:  "091f2de2472186c442ae24c9ff763df2b2d434a1fa0ca7500d268e58ff791f2a"
    sha256 cellar: :any,                 arm64_ventura: "a2209306dc2d303d47cc270a19a871c5f2c4f5ca7a717a8d4dc329702413de1e"
    sha256 cellar: :any,                 sonoma:        "c8eee00ba3f59650f9a59e1e1a6a8424daad7450c5d08d6d1808a4d44a179a0d"
    sha256 cellar: :any,                 ventura:       "4c54b471800cb1bf08765a1a8110bc8e2ea6c9620789b4adf5f669a6d087d16a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56772fbb85b860f1a6813151f01adee469d0dd31d77d66e84e4362df8ce877d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee17158a3b5586ec93fbbd1934dfb06d20314a6b8b73409530aa7de3350bff7"
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
