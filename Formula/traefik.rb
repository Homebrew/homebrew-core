class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.8/traefik-v2.8.8.src.tar.gz"
  sha256 "362612baec71ae37e9334fb4ca802707c0b85aeb92e56892124df736e8f9f97f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "355aafa1b3eb9f4618b8888a0be5e99a48e3462b82e69131e9f024ed0b5fa69f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c8d1cb6bb70a2832d846db7c12090d9df8c216efafef39287de35ee73c9ff97"
    sha256 cellar: :any_skip_relocation, monterey:       "55cdec8831e746286110c7c97cc0e246faa32ff3eca751f96eb5a869cd23e0c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bacf792546511852086b3b0f20c10bc519dc8f0f4f8c5490f74f3b1fe7187f7"
    sha256 cellar: :any_skip_relocation, catalina:       "bbda3ebb02f567b628a85e97b694ece8d9e2806a119e8998c422d0a7c24a324b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473ba6d3f6c77f19a077e9e2212cdcd01ab75d85b71f46c2471aebc6a8c811f8"
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
