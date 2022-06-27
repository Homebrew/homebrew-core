class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.7.2/traefik-v2.7.2.src.tar.gz"
  sha256 "d629c8f2d30d8b773455d763fb3e1ffe53ee8069d7fac9cae4a1648ff71ec8f3"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7769481de61eabddb265a54fd628ef75a32f0fcddfbc5ab8650ab72ef44a03c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ce2f534c0391caf6d804db6f45fbfa622a97e2a6a74ef03f03e20f19d2d4444"
    sha256 cellar: :any_skip_relocation, monterey:       "ecaa792fb9af0571aa45da6daea3875c0824499f9a74a8e318c71e7afd62ad90"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cd899914de3eed5ec99376be42bfd0204ed211465e974b212eb773276bf71f0"
    sha256 cellar: :any_skip_relocation, catalina:       "0e773366c0698599c1a7e121c7011ad9148efa3074d29210eabf2c45b63c4645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e360eb0025f00d1db2fced3b8292499017541d763c381d59f5fb3e0748db44"
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
