class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.3.1.tar.gz"
  sha256 "323700908ca7fe7b69cb2cc492b4746c4cd3449e49fbab15a4b3a5eccf8757f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "614c1bb4d3fdd65e452d7af66d5cac5e397ff452d2b023dbd1261e632ec346e9" => :catalina
    sha256 "a0ad536184c0f12c3c65710be453e810eda0ffa3b0109a56f69b364c05439703" => :mojave
    sha256 "a2b5e17e00e1c74b52cf0d44ba802bc6e0eb450e950530cedd7cef38e83437ca" => :high_sierra
    sha256 "5200608539895835b8faa52b886fe9181c23e94c560c4ef9f2f6afe842de3626" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/joewalnes/websocketd"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"websocketd"
      man1.install "release/websocketd.man" => "websocketd.1"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port
    pid = Process.fork { exec "#{bin}/websocketd", "--port=#{port}", "echo", "ok" }
    sleep 2

    begin
      assert_equal("404 page not found\n", shell_output("curl -s http://localhost:#{port}"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
