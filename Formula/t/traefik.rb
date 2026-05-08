class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.0/traefik-v3.7.0.src.tar.gz"
  sha256 "912d2c79f83fa44a97ea35273cbc6c245998b4a371ec807f4b6fee582058ff7b"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0fa3e3257dd7361869c2dce3c877684398e2239c96046a7e6c01747946a8b65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1c55d60361deb5dbddc2725e007910707ca8f2eb4050af965e6c8a0b0de88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb9c8ebf4858a1763b073d82b5c1314743a79b14f58e785dc9b9afaa7e858dce"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5d9557cb9a60bcb633ca8d631f2f1f136010f21edf8712c5278bb08b92d06b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a188bc7eca1b3b7665477b70c4d5cd2beef5122bfbd2ffb6128043d5c80c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87487e0f7f83e79267ce457fc5e1dda1195c5e8ca1e1410ccc3713118008bdb9"
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
