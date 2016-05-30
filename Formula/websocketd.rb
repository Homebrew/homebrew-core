require "language/go"

class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.2.12.tar.gz"
  sha256 "89440f28b5af985d43550bdeee3e04c4ad0cb2bc373af8e0563f176959202550"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb6272c915a2e11304fda7dcc3082745f15e323dcd75e2b3d0b8894e31e2ba8d" => :el_capitan
    sha256 "c7dffa33a41c4cd37b6c32b24ef72bcf52a66459940c788fb2ff29d4b6c7d24a" => :yosemite
    sha256 "b83fd95c900d994654ed40bf9c7f90a3674d4add5a7f8fa6fdcbdddb61fd88c6" => :mavericks
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
