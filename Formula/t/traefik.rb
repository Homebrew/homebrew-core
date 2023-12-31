class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.10.7/traefik-v2.10.7.src.tar.gz"
  sha256 "64f8fdcb907b8f6cd7431cf91607f45b576324bf224efe4ea0f3dc09e65db6a6"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f9e66e41cf7b5cbb6f9536fb7110b95f4b45b166397173cd76c1a9d507530ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b9100ae3b727d75569718091783df2084bf8b87b94a3c09acec5c2d0bda50c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fe8b09a26f67218fb5c95a5bb9a7612e6a5b13d7b1edc56814bcb053bc2ec6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c77c3c97bcc506081c859534c324ab770288e761aeb0aba9eece6bd00911c5f2"
    sha256 cellar: :any_skip_relocation, ventura:        "510f687161e27bb1b7c4c7c7857d81fe6aff9e07298b00df19865a34e8ec96ce"
    sha256 cellar: :any_skip_relocation, monterey:       "9226ffede6d5b309d4b01af6bf7f18a745e7d1d1c417ffefff4bb8635ee569e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4685e1586b4ef0c90ae965dffe5347f75b9735ce33b7a183ba578babdeaff4e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ].join(" ")
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/traefik"
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
