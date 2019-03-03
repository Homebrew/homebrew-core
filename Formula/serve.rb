class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/v0.3.0.tar.gz"
  sha256 "6bdedf3e3a83ad23cd867c480d32a9f1a91e4e7a289f81579ee4ff308c12d3eb"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/syntaqx/serve"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"serve", "./cmd/serve"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/serve"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
