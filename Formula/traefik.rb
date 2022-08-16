class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.3/traefik-v2.8.3.src.tar.gz"
  sha256 "fff69f8d593a2499fcda2c630656f23b01ac0647f6891d513c1e69d7b47d28fb"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae9b82a52b4b66644743c2db9bec3676e5d79fb9a232ca45c90dd86ce69c68d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29d964bf16d1c5ed0f9a5f83b7249fb62b6496e0095cb9efae94f6c0973a7046"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a7e84b74407390dfb276ec2c3b97ceb41cc417f9f995108a5e1e5dc5f6fdbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead87053d8486970a47fa500fe418e9a80df338c678222c89184116b137ccfe2"
    sha256 cellar: :any_skip_relocation, catalina:       "b56f6ca986fd23387983504e2444eb5291f54ed4c5eeed40816ce370ad152f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df0d18e6257292f0614d640acbfca11072504c35698d1b697529423485d0e224"
  end

  depends_on "go-bindata" => :build
  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
