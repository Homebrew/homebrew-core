class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.10/traefik-v2.9.10.src.tar.gz"
  sha256 "e670a3806939b2066879b9d8ecaf9b159534eb859bae8e536c7aaab0a42ba58d"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f1e03de9ee2518449ff5f557aa5786901e4fbd6dd974c9b696a6e2cc116c9ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f1e03de9ee2518449ff5f557aa5786901e4fbd6dd974c9b696a6e2cc116c9ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f1e03de9ee2518449ff5f557aa5786901e4fbd6dd974c9b696a6e2cc116c9ba"
    sha256 cellar: :any_skip_relocation, ventura:        "428deb50de064834613e303d2207a043860548a7a37f006efffbe015e97e5ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "eb38a51a8ba7038dee28b05a7b725670997b268aa196757a8e84ec6c79f1bd29"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a358f6387fbc98957455b2aaf99dec2c1a8f21631a4a8d3152d222f268eec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93cf0f2dca273db7bf267a93d1472ad2714ea589fef88ac65b0402d50834b9ef"
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
