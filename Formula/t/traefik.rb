class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.7/traefik-v3.6.7.src.tar.gz"
  sha256 "59158f0a46a8cfeb4766e4633a686a19bfb18bcdc44bedcca141e7e20aaa1a02"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af716ee298aa5c8e50f18fb7cbcf4b0a14604b97226a881af3f3321d8b0836b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b5f882c5b31d46042cd9033e686b533dcb3ca70c7212bac64399a2a19faf04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a766a15a503287d9e92120c7779e9dafb0212f2a9af8d3cdd6f8082f31f72a79"
    sha256 cellar: :any_skip_relocation, sonoma:        "338f458b59f454ecf439b296a0dfb796b02508b9a18c86015c166040991de76a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a00c3c8ffa975bb58aadd1ccefaafaba842ffa7914f6b5284d90c88161a3c63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c2d00de114c5d32a6f32a344f8aef8a26965b9cc1cb1bc501edb3d727f76ce"
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
