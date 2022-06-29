class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.7.3/traefik-v2.7.3.src.tar.gz"
  sha256 "ddf1f4933a49df423006eec890930e90151d5cea1c48a6d4360945e8ff930458"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb697598d51ec5a594a5fac49644ed1a39982636612627d6c9d900367856870b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "382a89cc306c084b6c1ae93babd66c94d5108fdae122f1c661a6e8427cf3d347"
    sha256 cellar: :any_skip_relocation, monterey:       "f471f6d9e8dfd78f9c9526bd42a398866aae0456d12b5ed465a2a4befc95c865"
    sha256 cellar: :any_skip_relocation, big_sur:        "81bfcf7648e9e07675d4a7b1719f02f56296080f858aa4233bfbe4d5a6cb16bb"
    sha256 cellar: :any_skip_relocation, catalina:       "d51596680699b92436f0436929efbfe1a57ee8a5d5a7fc3cfefecef351467b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9f46d7a2d96644be136e6eaffbf3dbfc35222f14280e6b25142185e12935d8"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

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
