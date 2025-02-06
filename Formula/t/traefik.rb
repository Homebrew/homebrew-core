class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.3.3/traefik-v3.3.3.src.tar.gz"
  sha256 "bd08e63a919e90afb171d6df8ac4a426e309d6df6853c92657bded2da805dbec"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83bdeb36373a8843a4ba28e798e0d510acd5afcd2a54d2609bd05d5db0c6814b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83bdeb36373a8843a4ba28e798e0d510acd5afcd2a54d2609bd05d5db0c6814b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83bdeb36373a8843a4ba28e798e0d510acd5afcd2a54d2609bd05d5db0c6814b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b1bb5b47feeda57a21345222ae1ae26dc9b9f1ba924ecca7221c193e432a60f"
    sha256 cellar: :any_skip_relocation, ventura:       "1b1bb5b47feeda57a21345222ae1ae26dc9b9f1ba924ecca7221c193e432a60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c72df23ebe5d3ae0ccb55037aaf7048c1c6200cab963dd82421ce4899d9e31d"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
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

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

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

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
