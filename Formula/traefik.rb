class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.1/traefik-v2.5.1.src.tar.gz"
  sha256 "46e60fbab64c5ba87517caf83431149f7d076e8d6674a72a18c789672014a1a1"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7a7c73fb7c2e249e1b718e0ab1d383f56db368862d9faf035c54dd0b5e69b87"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7d9cc1fd4d3b8c1ddbbaa1080a455d0e577708cad0fdca9790241a4c08aa154"
    sha256 cellar: :any_skip_relocation, catalina:      "6b0bcb17a65d47e5936a4a58b633c460025d22f2e17760d53573ad394f90cc3c"
    sha256 cellar: :any_skip_relocation, mojave:        "f64ca71fd8267ed416f6037af23f774ec4af98b51a186eebb9c6d9158eb1425d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6a36449a23f333e02b1ea4bf7d6cb5220d58f662a64a7008fcefc56943ca4d"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/traefik/traefik/commit/352a72a5d7ed6caff2315f92d61f50c475c9f137.patch?full_index=1"
    sha256 "ff99dad7a1933b87c94e0bdf22eb38a69c09ffb9c4292f2112359ff1bbe3020f"
  end

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
