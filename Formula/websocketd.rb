require "language/go"

class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.3.0.tar.gz"
  sha256 "f59fefdf79d6b99140027b3c58ca77d59bb3c1fa2f15969d7239538b04042b3d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "279b5cd3903dd5c7102f0816b8313da2db11ea8a2e0f939973ed931018569784" => :high_sierra
    sha256 "d846ab4fd91bbaac4734b7b552f2ad2cf1e40768a1ecfdd0529d2f791726efd5" => :sierra
    sha256 "560f7a2a5455bbd31f0f30f3beba292543bfb1e7fae6a1ab5d0b2c1b3ebe6904" => :el_capitan
    sha256 "1b525264a32863baf094ec1e6e2a9b932b79aa51135cd20b26c086a970294d48" => :yosemite
    sha256 "db7d13cd8b3888f830f2c2c566a045dce4ad3cfb18c193472c5f19fe26d1700d" => :mavericks
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
