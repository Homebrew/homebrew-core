class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.24/traefik-v2.11.24.src.tar.gz"
  sha256 "6f505d857ff5c0b06dc8fe7ec5d8f59afdc8b7157b3455d5899313e52542ca89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73048dcf01645f2338386b52a32d1b1c2b89d5df2c38caf674a34d6f5ba3906a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cedafb4b6da68660a07ad28aedae8010f2e9cfe9ca375db31269c97790cb3b53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "485b4f744fb8916575df6401bbd142b8d1d35afb671172d12db00c52840255cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76d43aa4d9340c31cc641d3216fb88e7c1c422aa0d60807b144ff205788d4ee"
    sha256 cellar: :any_skip_relocation, ventura:       "72cc24e148cceb839dfce62a05a10ebd2b9ca6e55055e4ba9216a46848435647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ec92cfef643d9ec9bd6fcbb9df1885efdfb906da26c3a324dcbad9d9ea8190"
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

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

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
