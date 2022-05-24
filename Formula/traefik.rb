class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.6/traefik-v2.6.6.src.tar.gz"
  sha256 "3ebb59c8286fa1138c2615de404fcc232316409da8a2046e2f7894c3c000766f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d70f93ae91535e01551267b2fce9c54f3f47dbd5a79f6911fb84b837a9630b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39be2af0f89acbdc30de3b6be374b87b5e50c76735ef6db75ce3b91e2bfe18d4"
    sha256 cellar: :any_skip_relocation, monterey:       "cac706f204900a74d6656121dcf1971fe82f4e323e9d6995301fa50ebacec143"
    sha256 cellar: :any_skip_relocation, big_sur:        "e603595bfd6d615017102be892a1766ed3ee5ea6e49dc972b07735cc4a01e923"
    sha256 cellar: :any_skip_relocation, catalina:       "31aa1ccd9527888486fe56964e457798eb8732580ce1b5a1d017e29826c39699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32bf3d7c658dfde6df4221c6d5d2b0680afff8350b6fbd29a536f3fd6689a988"
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
