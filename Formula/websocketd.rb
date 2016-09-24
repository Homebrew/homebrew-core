require "language/go"

class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.2.12.tar.gz"
  sha256 "89440f28b5af985d43550bdeee3e04c4ad0cb2bc373af8e0563f176959202550"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "560f7a2a5455bbd31f0f30f3beba292543bfb1e7fae6a1ab5d0b2c1b3ebe6904" => :el_capitan
    sha256 "1b525264a32863baf094ec1e6e2a9b932b79aa51135cd20b26c086a970294d48" => :yosemite
    sha256 "db7d13cd8b3888f830f2c2c566a045dce4ad3cfb18c193472c5f19fe26d1700d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/joewalnes/websocketd" do
    url "https://github.com/joewalnes/websocketd.git",
        :revision => "709c49912b0d8575e9e9d4035aa0b07183bd879e"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "30db96677b74e24b967e23f911eb3364fc61a011"
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
