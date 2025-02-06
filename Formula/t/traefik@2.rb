class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.20/traefik-v2.11.20.src.tar.gz"
  sha256 "3852b76dfc9053e3354649c76c1ef7c1e1dfb8123d7150281495bf25f93fcdce"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e90ea9a97bd844f3a999e30d170d62a9d5a7bfe590d1b4734476b6263b5fcb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2eeff8b0ab8417d1ee7f5a034039305f0f63abe9c6612bbf8e3982e999ad519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ec7f78e94a574ffe34af759a721161154a3879dd742d279d8049de2fa383639"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4f072468480597d3be732ab6b3b26fececba8991c9d04f328aa3c9a077d7afe"
    sha256 cellar: :any_skip_relocation, ventura:       "0e369a24fc7d1362ba3799746bc0b77632a0f424742614d8fcd4d565eba111c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29a9e1ac043b5ec0f5cab9b517fd8f99a55bb835d198d06656090889e2ee861e"
  end

  keg_only :versioned_formula

  # https://doc.traefik.io/traefik/deprecation/releases/
  disable! date: "2025-04-30", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:, output: bin/"traefik"), "./cmd/traefik"
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
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
