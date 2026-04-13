class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.13/traefik-v3.6.13.src.tar.gz"
  sha256 "4691ea5e277c7a074c5296881c8b57027bbccf1b831e0ac3802a2e559e9e964d"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13675c6411b35526ee1df647703f528eb3326fbb14102fc6ae88390671cbd721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2ecb81794902c4808dfa85fef8041d0d7bdf7f187a4d9a677e781fbcd3b868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c28b2eb352f77e76b019e65757c631e07dca8fc1b09aab806c6d88744903306"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc5d08f0dbbda07f1f86c851bceaefac277aa33787d04198e5d262196800d7c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "684d45f41e9dc7f9bdcfb55854c23d84e3757b55c528c2c5a2f25eebefe25220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05e473b63fc3f7befe2bfa9430a101cf6d2e81e7ec07673f250ade99d02a1f6"
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
