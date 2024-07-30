class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.7/traefik-v2.11.7.src.tar.gz"
  sha256 "d25009ab4d5e9be3bbefe1778d3c733379a2ea5d36b47968b2edecabd2975c82"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a1e62cf5359649b47084718c073818143ed7c1fc951d03066a7e7ceea163f24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fdff11653504d113fb2555cbef79dcc746a18b00f53aa0b847d6810f5e4cc6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c482e6284333ec713fbcc423b7fffda99c3b06c989b691f3b60a511ef11eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe8e85d8bfae0cf12507b43bbeda44c3bd8f6093162531ea97487aa5427598a7"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6a67854f60bc4b21f8e4dd6ce72689680f493593af373b96ab6665c89bf3fb"
    sha256 cellar: :any_skip_relocation, monterey:       "c97d8e8fb67f7efc6e93a8ae208c80c1bbeb8bf34b55c80e187c404fdfa00905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cdd37ed59cecc0e06d6aa6a3fc2d35313c700ffee07c8fbc0ba3879fe798992"
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
