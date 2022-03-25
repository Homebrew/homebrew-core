class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.2/traefik-v2.6.2.src.tar.gz"
  sha256 "406c27983aff2a959d2ef91fa85246e2495a511ced68dfe78b445e2084f9e6fd"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470f2e3cd8a59a2293a73c3aa61d2ec0bac5ade053abf9b3966d75090cb2f07e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "871ffc99145c7610f754f696a85dbd256e69fbf388d211357fe394bbddfd242d"
    sha256 cellar: :any_skip_relocation, monterey:       "41ba137ccea207ff7787772e64b0b79c5bcdc05f7591764f71b96c7b4eac568f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5c9ca94aabc889d34ecd8851297c6edf03c822e4091224f01a9d62636e724ac"
    sha256 cellar: :any_skip_relocation, catalina:       "19f1e5494136416b9a17df8024a55038cbc461997912d5fb4725bb28b5842cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb9e178336fa70d2b2d28b3a5e71a8157b7682faaedd979b88f1a97848a9876"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Fix build with Go 1.18.
  # Remove with v2.7.
  patch do
    url "https://github.com/traefik/traefik/commit/9297055ad8f651c751473b5fd4103eb224a8337e.patch?full_index=1"
    sha256 "b633710c7bde8737fbe0170066a765ee749f014d38afd06ef40085773e152fd0"
  end

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
