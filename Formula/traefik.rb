class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.2/traefik-v2.5.2.src.tar.gz"
  sha256 "dc3cfeca6ac7d9c1eb520d9eb1ca2687afa132ee4c2439e39e0760723f128d6f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecb4867cc888c871b89f87f462c9c118d3aaf17b8f9a62add9ad378599f8fc5a"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f53a074aa6ff575be96aec04efc5b1cf2495820a54eb05d46e3d305ff47a07c"
    sha256 cellar: :any_skip_relocation, catalina:      "62f476f37872685676d29e0494bfb5cf6497f539f52b6c6742fc48a4c08a33c5"
    sha256 cellar: :any_skip_relocation, mojave:        "a9302a157809a477dbb56c20b4625cbabc2d527ae2222cc255299f13cfdb8c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30800a2c69601817d72e5abe32b19af3670599548b8ad2360f74c9b89572f3ad"
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
