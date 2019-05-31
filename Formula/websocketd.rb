class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.3.1.tar.gz"
  sha256 "323700908ca7fe7b69cb2cc492b4746c4cd3449e49fbab15a4b3a5eccf8757f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e060ae07f4fcb9cfc4ff0eb8c3bfdd11135966957f4d2dcb84de0f4fbe15de2" => :mojave
    sha256 "69523ab9efd2f2b8f595b4ae4d282f6af64fbbe24fd3b16b7011210b8d1ea87b" => :high_sierra
    sha256 "38ebd8e10260501352e81966e3bba46bf00d38e00b408f763ef8042a418099e3" => :sierra
    sha256 "eec1080e0a40bf336ea48950c1c21e0ab50e038ee46874cb59bd6b16791309a3" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/joewalnes/websocketd"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"websocketd"
      man1.install "release/websocketd.man" => "websocketd.1"
      prefix.install_metafiles
    end
  end

  test do
    pid = Process.fork { exec "#{bin}/websocketd", "--port=8080", "echo", "ok" }
    sleep 2

    begin
      assert_equal("404 page not found\n", shell_output("curl -s http://localhost:8080"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
