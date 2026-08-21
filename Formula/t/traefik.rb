class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.11/traefik-v3.7.11.src.tar.gz"
  sha256 "e046727bf3a6538f7e2205ca0ac27334441102d01e3a854af710c03a138125a1"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80029acbde49d82560fef0069b629d32ac33ca4658ebccf2182d354f57fcab0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098b00f9776f60eecc215955b30de9e385c53bf9fc78d243c41a342f364a7b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d8dca7288f320417d416957ec6054c582bdfaef86c85df24e509048c06e73f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e32e4dfebbb6f03f920ab51ec1d26b9e874127760374d6dc47ccfe7690b98f24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46cf695ed8de05a8cbdf641676d23256340aff6d545e1c5a2bcb480459082568"
    sha256 cellar: :any,                 x86_64_linux:  "ec1afbe1dd71e29b79207c853492b6f085cd0a52aae229837f631c215ab914ae"
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
