class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.1/traefik-v2.5.1.src.tar.gz"
  sha256 "46e60fbab64c5ba87517caf83431149f7d076e8d6674a72a18c789672014a1a1"
  license "MIT"
  head "https://github.com/traefik/traefik.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bff865bb9e5ede0842673406007370213a4d4c446d79e6505536d0a22cfff57"
    sha256 cellar: :any_skip_relocation, big_sur:       "85d43c146efb229e1b18cff1ee7c84dfcac9149bcb2311f1b39c3e03e164b083"
    sha256 cellar: :any_skip_relocation, catalina:      "d12e5f665f6b37d305c1a1e40ad6100dcb2a9308975579e1361e4066f121b3c0"
    sha256 cellar: :any_skip_relocation, mojave:        "99ab4d67f75d153267d366508f474c851966a8eb2e90d47fbac8ff72260ffc66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db79e92a2e9f9a2a2079339ffa0dbbfb45bae3845879092e743ba61e9b22663"
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
