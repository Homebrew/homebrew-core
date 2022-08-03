class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.1/traefik-v2.8.1.src.tar.gz"
  sha256 "27c79c8fef47e51bad0a76edc9ca32d61eb11f39b57622c3add0d994fb721edb"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82255c8750a70bdb1b4857ee4f2c49071f181c72695d06270f508766b6bccf66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9813649f1a2121b639492e787f56619571a5abdccf9ff20091d1f3a6b1576dd"
    sha256 cellar: :any_skip_relocation, monterey:       "a7a3f26b20f1b2980fec599eae93837cc9a90df9923e8968dadcbc4de17c3ee3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd695917e76bb4c8f0010399c91b56415baa2fc5f5fcebae1643243517b7c084"
    sha256 cellar: :any_skip_relocation, catalina:       "90170fcb1b67bde1ad2efdddbc8b41d1224afdac25acb7f48590f863d3fd9111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417dfc79bd3b7e669213859114a578405120306139a5b4e36bf781b0112a5393"
  end

  depends_on "go-bindata" => :build
  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
