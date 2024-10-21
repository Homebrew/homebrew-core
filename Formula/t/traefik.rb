class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.1.6/traefik-v3.1.6.src.tar.gz"
  sha256 "88cd6b1f871894bcae5e2c9eb356b13aaea815368b9c68a0ff4a466b6a05d02f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2904f9094a89e3ac1e205e68f7afddfb4dd07ae16c7a2d8826bcca46b3ab2b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2904f9094a89e3ac1e205e68f7afddfb4dd07ae16c7a2d8826bcca46b3ab2b24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2904f9094a89e3ac1e205e68f7afddfb4dd07ae16c7a2d8826bcca46b3ab2b24"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e8b2eac048d445df763db8616ce66397935e26c15521212825a047d2d4240a"
    sha256 cellar: :any_skip_relocation, ventura:       "f8e8b2eac048d445df763db8616ce66397935e26c15521212825a047d2d4240a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9763687e8f9fc56c215e6daca1f7997ec09ed8682e2b6dd5b32b4855189156c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
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
      sleep 8
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
