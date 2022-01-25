class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.0/traefik-v2.6.0.src.tar.gz"
  sha256 "d3d68259e9cce06f735fb503caed465294dc167fd117a94489f57d9b00dc3c74"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed3fa5c4e79eb1c159b286ca4c40dae1c40f6be536ce3743bbda7657c7acb7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4147b4c255ad566921ff3002c136214ca0f49c1847ae3ac5c07539cc5f961328"
    sha256 cellar: :any_skip_relocation, monterey:       "786ec13f26c8ca26abcd1fca26f187b75a75dd89a924e5520b484e95579989f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f787f5dea973a6d19b1fd1c0a5497a76fcd6c8619374780f3c9eb33e1aea5198"
    sha256 cellar: :any_skip_relocation, catalina:       "c6889d22c30d5e12d5568939c62decc96318ea9c0bd0a4d8f24548c13e9a2dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06eecb3c7ba7bbbe6265a2a20815a358b043f86a1914b2f3113c9618ee65409d"
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
