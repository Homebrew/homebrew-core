require "language/go"

class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.3.0.tar.gz"
  sha256 "f59fefdf79d6b99140027b3c58ca77d59bb3c1fa2f15969d7239538b04042b3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e060ae07f4fcb9cfc4ff0eb8c3bfdd11135966957f4d2dcb84de0f4fbe15de2" => :mojave
    sha256 "69523ab9efd2f2b8f595b4ae4d282f6af64fbbe24fd3b16b7011210b8d1ea87b" => :high_sierra
    sha256 "38ebd8e10260501352e81966e3bba46bf00d38e00b408f763ef8042a418099e3" => :sierra
    sha256 "eec1080e0a40bf336ea48950c1c21e0ab50e038ee46874cb59bd6b16791309a3" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "cdedf21e585dae942951e34d6defc3215b4280fa"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/joewalnes/"
    ln_sf buildpath, buildpath/"src/github.com/joewalnes/websocketd"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"websocketd",
                          "main.go", "config.go", "help.go", "version.go"
    man1.install "release/websocketd.man" => "websocketd.1"
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
