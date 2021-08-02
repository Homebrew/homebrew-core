class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.4.13/traefik-v2.4.13.src.tar.gz"
  sha256 "b6ca4b74ead11c19bf9ab2e9ab6b08d05b6c80a5c63be0b2c943f57f9a1767e3"
  license "MIT"
  head "https://github.com/traefik/traefik.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd7763f06a072e65a29bd3aa8aedb9f089a0988ae6a16e3a4e979668130059d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d8d876d792101d827c794e3e42cc3f4a6941e2005599cfa18084c87cb185e8ed"
    sha256 cellar: :any_skip_relocation, catalina:      "72c05f0a11247c19ff7f2fca949e595024b27e3d52e1f2470fa962a3f9a0cdb8"
    sha256 cellar: :any_skip_relocation, mojave:        "2510e7ee07707ff1f3c199670f5365a635281c6d169ca18113d61ebc45b3a09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8450cf8f7ac33fe87dc880e99c28e611164eeabceee62383c93151a88daae4e7"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go", "generate"
    system "go", "build",
      "-ldflags", "-s -w -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}",
      "-trimpath", "-o", bin/"traefik", "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc/"traefik/traefik.toml"}"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
