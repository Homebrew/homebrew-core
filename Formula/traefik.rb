class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.7/traefik-v2.9.7.src.tar.gz"
  sha256 "9de2f0e7e4880d1980d3c6083ddc30d1deefb17a8b99c81ce1511fa3355ac108"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde1c0ebe7f0a72b68e3df14ea87459a89cce48b5310af6d9aff648b8ea28ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48a5557299ce4717ff440998bea100ac413bb70e5b86049efa54a6526a4c6c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db02034554c44fa63e6a6e7499c1da7942d2dd7b486ad16e29cc71da8f963f2a"
    sha256 cellar: :any_skip_relocation, ventura:        "99f940d989f5ef07d870a3b83ffcadeaa0113064ab1c443bd728c7c0c70b5019"
    sha256 cellar: :any_skip_relocation, monterey:       "f25355be4d0be7144ae7b5f8eb8e8b9e7eb9192d799e764c604e11747f87df4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "18b971c87b3d998e2e2946274d89571a11a18e69b891c85694ced771a1b6676d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd73aa2329d3635884b0e38e97711823c3dd63fc9bb21e01ce046673f4476ba"
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
