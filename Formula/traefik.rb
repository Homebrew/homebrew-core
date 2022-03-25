class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.2/traefik-v2.6.2.src.tar.gz"
  sha256 "406c27983aff2a959d2ef91fa85246e2495a511ced68dfe78b445e2084f9e6fd"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d2734b64a9e5b48e0351d43c93c33feaa19f617d9db8ed54fbb5571ea8d6fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d970c2f6a8bc23078853762b13a104db3132dd130a81e41f0fda039f1c757ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "10ec78e67c96695bc2071941ba1a7c27edf81ffd17d1bdf371956abef1f60ed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "877fc04a6dc3c6c4bd17cff39b903b93323c74c343fe08e0fcf7b4d0d5a88140"
    sha256 cellar: :any_skip_relocation, catalina:       "76ff2356fc0d3a06746bbd760b21c4231d289a70948e623b8e3c45ac6147d0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ffe7cdb72897be29f944c06658e304e10e16642ac1e0951215170c2ef1556f"
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
