class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.2.3.tar.gz"
  sha256 "dd7e51c90308ad24654b047bfc29b82578c8e96b872232029ce31517e90b7af7"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "168f4ae813ddb1e87be0f3295d84558054d32ad26e5715d34cc064696a12bf2d"
    sha256 cellar: :any,                 arm64_sonoma:  "20c820808087929316aeed64fe61933e8ca79a32c4c87c8fb58793772ddc31a2"
    sha256 cellar: :any,                 arm64_ventura: "bd3b7d52ffde55ec61d705f0d535418f8cdd64f04a963a037defa39a889866d0"
    sha256 cellar: :any,                 sonoma:        "9b1c5a9a7f6e195c18e158eb5e5429caa1622c2d2e477a8084d3756241f7c38e"
    sha256 cellar: :any,                 ventura:       "9cbf3fa74b59722fc2b864d18647384e71cb03e30144ffc25a9c0dfbf53a2f72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc046dfb08091e6764ace8825d837d78d28156c7ee8c03e165068f858e7c48af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc8c9b01bb5d707802f3029229ffa0aa90d44b39f76d8ce6e3b38a5ae0959e6"
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
