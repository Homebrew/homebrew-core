class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.18/traefik-v3.7.18.src.tar.gz"
  sha256 "d7e6c551bab6fdba4f1afc22945a1671f4cffcd42e3cd093da7e1a727f03df1f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2b91e64e48dabdca63d6393f0ad0086eb3b0b221ada3a5b9df43b81978e7bc5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b585cd7f9584d993f754f1337e9f084ddcfbdefd3bfb3f20be7d79aa3a744ed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "173e4872a86b2dad22f32c4383b75941e27b968a25093c929f973e8393457549"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82aa16059dc73577410b26240ae4ef27993a4f897c5f80a6698303916f0c4212"
    sha256 cellar: :any,                 x86_64_linux:      "173a43d9956545253a3491030919935fa8f1a47cf9b70742ec5751bd59c30166"
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

    ldflags = %W[-X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}]
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
