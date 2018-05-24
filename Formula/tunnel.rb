class Tunnel < Formula
  desc "Expose local servers to internet securely"
  homepage "https://labstack.com/docs/tunnel"
  url "https://github.com/labstack/tunnel/archive/0.2.7.tar.gz"
  sha256 "6b4a6564732e2e86e49450629a72dc7ef647088ef66f568cb507d1e0c9b5588f"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/labstack").mkpath
    ln_s buildpath, "src/github.com/labstack/tunnel"
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
  end

  test do
    begin
      pid = fork do
        $stdout.reopen("#{testpath}/out", "w")
        exec bin/"tunnel", "8080"
      end
      sleep 5
      assert_match "labstack.me", (testpath/"out").read
    ensure
      Process.kill("HUP", pid)
    end
  end
end
