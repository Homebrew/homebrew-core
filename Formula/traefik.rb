class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.6/traefik-v2.5.6.src.tar.gz"
  sha256 "dfa1eb9772dd5ed7711924dda307f616ddf32acd17d7b46eeb68d63d60de5de3"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb20c0b77050018ead876eb616876864340d51792b9bd6c040e68766d61806d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e8f306476040da73b9f433de5233f82e9db646a413dd74e854298c2f7fed4cb"
    sha256 cellar: :any_skip_relocation, monterey:       "a94ddd75a3eb75df2f6493693e46a1403780c115989573dc8cd812971ac6b107"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecfd0d804284484d7d7aa826755f3c43148740a8f8fb80571db7c8230c31ffe6"
    sha256 cellar: :any_skip_relocation, catalina:       "899304bcaf98083f147af06f08f8c9a75d0914aab7ae404360e7fed4dfcfb51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b82dacb13ca646b2b181336a768b6b9e2a6a746c568417d8cc5b9df8880920"
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
