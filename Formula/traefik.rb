class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.3/traefik-v2.6.3.src.tar.gz"
  sha256 "5cffbcd97dc8138c87fbf8e6c3c692edf09ffea4555b21c8fdd0dd47a3baaf3d"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dde6ef76853fb26e794c6ea22efb4ad46b2c46292e4df0a1057c9874b62a7fa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "718fbbf4006dfb863ae978dd7a80c1d906c090efc5a8115cf50cd3c3fa81ea84"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0f85f1aac3eaf44a33f5392be5479dbc8437fc3401229fae7561d0a4585293"
    sha256 cellar: :any_skip_relocation, big_sur:        "df767bcf4719a07eabf8bea23172448cb0d369c4e32cbee2992837960faca511"
    sha256 cellar: :any_skip_relocation, catalina:       "5e3e0b7af24791e3f5a8831d9577fe836472b11a23ece498081c08738caee62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b355ddb70fb40c720165e46928362d5d2e14e3a4c99e8d7595b84e4f5ede10d2"
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
