class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.7/traefik-v2.9.7.src.tar.gz"
  sha256 "9de2f0e7e4880d1980d3c6083ddc30d1deefb17a8b99c81ce1511fa3355ac108"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9f37b5c6b8ba0ce443defd18ed103860268f7d45cedf84522ae3b0624cf895c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2b3e002ebef3795290fe0f1e460c8de9e3e88ae03c0425ae65485aeb9977436"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa64a69f00a8bfb92b172fa52daa595b91dfc9dc13be1b31b81778ed719aae48"
    sha256 cellar: :any_skip_relocation, ventura:        "2c2364ea962a2ad3f954b6689adf470c8fa3923f5b391166c5051a543c2f0169"
    sha256 cellar: :any_skip_relocation, monterey:       "b7be38d9b369b4bcf757febf48eaf8f048449685b139d8a069903f1432b83513"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7dabe194f05b94cbf6aa0dab53ac3e91d30bc090b413b71be80aed543d4fb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c001e11247bd4449152a2f744876a776fc83ed5d61c7407a6af7739d4df86f"
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
