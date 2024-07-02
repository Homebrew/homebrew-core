class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.0.4/traefik-v3.0.4.src.tar.gz"
  sha256 "6e9fff2f62ea01592e2530f36a7db6bb14cabd5161543d7b01faf48366a0ada8"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "774becd12631008d46b9cc5e5c6685d40eeef120fd4be3017cb349991406d669"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6aecbdf3812a95d1b698babdcb6bb36a76b1a98c46a6c13b85156cc6e5c7d41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db67590c52f0178f8bbb0c9ae0f55aacd890f4be2db5e50492b38ddca12a4d57"
    sha256 cellar: :any_skip_relocation, sonoma:         "3be2426bde0bb73c39b19184546c31d821cd2fca29b294aa3c6466d96adf13de"
    sha256 cellar: :any_skip_relocation, ventura:        "7d113f963b3c3e8228f679cb4491a7877cce1593660c2e4fdf9405637dfa8ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "f289984a7c09be7f34f4e759d072ae48985b7b46c8b0c4b8deab13ec93704e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872fae4e24a07bfdda6e339743e936240e38dec3cc2f3d899eb10b53ded28dc5"
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
