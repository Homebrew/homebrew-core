class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.8/traefik-v3.6.8.src.tar.gz"
  sha256 "e7c2aba0c695579b96f38a11b5400289697617a584f97e1b2fd77a3a252e1be3"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97baeea7089ebfeb96e03ecf3a1421aed3ef0d4d98f5e988c8e2b0e2d6f2de83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36fef44b67a1596b22621c5779fe5a4dc5eb4c6b70bf2aef8753de1ffaa2452c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4ed6d800ad5fc8640ce17c22c2355f514d3120787c228cc4c1210a963f5604"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2d2c3c2796326ccfaf870cdf5e0800ead15566de9eba7f091d7e54f59f61bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f06e22bc4e023234608affc23152d3ed97d465287a847d20a5f7787d4dacd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d48e058a733e11955904e6ee037a44536b57c264c7f5adbf370cdbfe7003b5"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
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

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik Proxy</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
