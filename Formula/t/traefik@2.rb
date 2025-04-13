class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.22/traefik-v2.11.22.src.tar.gz"
  sha256 "bf4fd5d33e5f30c08c22ed81e083e5dfcd20e5af74d52b70650bb6798a3f4395"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edad0c60ad1cbb8388d29a66eae44f3f3019b9b64e0fa6782f90f551faaf75d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58cefdc584ffd686a856f4d13a6c602a41cbb6599053f8f263d1a67c9f74cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37f2545a14cb379565b2ebfc02e0577c3131928a32ea20d1e78692a1e703d720"
    sha256 cellar: :any_skip_relocation, sonoma:        "e98ee83b47d20711ceabc87bcec29323e06cb202d5e640a3446b4e9d6c41fc55"
    sha256 cellar: :any_skip_relocation, ventura:       "c70b48108963d914c341c1447bb706d3ce97437c4908694a4cb6a26441e5faec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341a4b7fd7b8c58298c4c2294710d5f0475e95a8be60868cac36ad16136428da"
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
