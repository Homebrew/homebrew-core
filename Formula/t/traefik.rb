class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.8.0/traefik-v3.8.0.src.tar.gz"
  sha256 "50d67f39530225c4b8cd40ae97e85200ff3ee3e1e3860a5f970383a9f240e1a5"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "276c857fe4e3032e9dcef151b6abcab481dd1aa05de1345aa81613b3c732f941"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6aa407fbffc1beb4200dc3077bd1624b64614a1870a520c4ee0515428e9433d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "789774e5d382417bb220b5548334cf0273c084c0cfcbb3c6e677b2f0c1b08812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b261b781f52fbef498c2f1cc3a6f69ac688da951467c6b15a96ad80db0e8815"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8844336711dd03048f43840bd4435fe0026ef30a7d8eeca3c80f4052342a867c"
    sha256 cellar: :any,                 x86_64_linux:      "95c7ac3bcc08a8fd573f44715da4685e319c8f856affca6a05f43a3f41808270"
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
