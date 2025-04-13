class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.3.5/traefik-v3.3.5.src.tar.gz"
  sha256 "26f332f4c045f7e02923c0f14ae674f7f07e5b8d383d2d1d9e4342b554e387b4"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7508ca13356ee9a46be9f8f41de0be11f079d01bd52d40b5e384d5766f49df4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7508ca13356ee9a46be9f8f41de0be11f079d01bd52d40b5e384d5766f49df4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7508ca13356ee9a46be9f8f41de0be11f079d01bd52d40b5e384d5766f49df4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c78e1e52ac9daa1a240fa0a9e8a7f3179e8f1b6c5f29bfb5a1071cf258cace"
    sha256 cellar: :any_skip_relocation, ventura:       "b0c78e1e52ac9daa1a240fa0a9e8a7f3179e8f1b6c5f29bfb5a1071cf258cace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d98cb2ec5116e5e9c12a9b22a84cafc7f7c92bb152651023567309bb74683e"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
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
      assert_match "<title>Traefik</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
