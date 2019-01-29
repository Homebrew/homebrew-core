class Serve < Formula
    desc "Static http server anywhere you need one"
    homepage "https://github.com/syntaqx/serve"
    url "https://github.com/syntaqx/serve/archive/v0.2.0.tar.gz"
    sha256 "ff4d33c2d7fc95546023f3710619098e4e3220255a2b09ec67ed6cbf57ea4d06"

    depends_on "go" => :build

    def install
      ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
      (buildpath/"src/github.com/syntaqx/serve").install buildpath.children
      cd "src/github.com/syntaqx/serve" do
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
        assert_match /200 OK/m, output
      ensure
        Process.kill("HUP", pid)
      end
    end
  end
