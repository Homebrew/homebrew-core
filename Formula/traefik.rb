class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.7/traefik-v2.8.7.src.tar.gz"
  sha256 "fd76d5ea7bcd2f75f60b9abe99b4096e7312ab41b9e008d2d1a6009a8dc8296b"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9222aaa7c8936d90c5cdea573e9888b3a597fe2dcb85aac2a7bac986c9178651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24b52dd85496db342f99bcd4a71acb4e1d2cb062f3ab8dd3ddcaa82731ce8e93"
    sha256 cellar: :any_skip_relocation, monterey:       "e85f9f903d8b17eed635b99fa32520bbddf80d62192e0188ca2f9f6444c711ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1eb4c0d4f50483b5a576e2199732bf60060fc12b39cd17269a0483008f703a"
    sha256 cellar: :any_skip_relocation, catalina:       "0badccf5c798ff6f774ef1a8266b198ce44ac4233d7aafc36ffe6cfab56e1874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f72b65ce8b0359f2dfa901fcd719a3c8327e2af4f66d184125bcb669f30d5d2"
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
