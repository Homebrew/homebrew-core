require "language/go"

class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.2.12.tar.gz"
  sha256 "89440f28b5af985d43550bdeee3e04c4ad0cb2bc373af8e0563f176959202550"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1aae82fc721119bea2b9c4eeeffcca73e1b95b35f7ed18aa845bedd0d49217f" => :el_capitan
    sha256 "ede9acb8e57e5da83bfe01a9ef75aaecfa38ca594eca150c8d885ea9d3a5acd5" => :yosemite
    sha256 "f362300b0088de2ff7f918d80aa3bcdc3afb65eb3b6e8fe7c96ec815a16a9ba4" => :mavericks
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
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/joewalnes/"
    ln_sf buildpath, buildpath/"src/github.com/joewalnes/websocketd"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.version #{version}", "-o", bin/"websocketd", "main.go", "config.go", "help.go", "version.go"
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
