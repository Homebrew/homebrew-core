class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.12/traefik-v2.11.12.src.tar.gz"
  sha256 "4877795dbc5ac9bd3e7e3f68e1f6965bb8ad818e43d0a5b79a1dff386f5d4be5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5faa5e9a6df9e51d99b8a4415d16338cf76f9f26779101517948ed6b1ef59db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4259df5ee7140b3294cc3f75101471c2805eb2f7ac9841be4b20fee30836bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bac3b920c6763146d0faa893728602555413db0612f7730fd859564153e4f0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f99499fa48baee49ca566f43ceb75c08febd43a90af44cc6a393d90a2577cd1"
    sha256 cellar: :any_skip_relocation, ventura:       "c6ea7a17f09484dd2233a01fcd39b8d2abe899e8ad27f85b5590ccaae326d2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49f6e5e5c41905f0bff4fb3df1519c6c7e4d13c30fd226f71ae17cae94516e39"
  end

  keg_only :versioned_formula

  # https://doc.traefik.io/traefik/deprecation/releases/
  disable! date: "2025-04-30", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:, output: bin/"traefik"), "./cmd/traefik"
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
      sleep 8
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
