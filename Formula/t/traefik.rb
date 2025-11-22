class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.2/traefik-v3.6.2.src.tar.gz"
  sha256 "136408aa009b378bf8d6aeadcdd9a78c7428f4e9d3b9de61b2f149e640d058c5"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e4e845d755fb29b7d2f8db85bf89ade47118814fd8941e7d2fe3ad6bccaa68c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20cf7c1e974e1f2a18adfb6ef28f1e962003edcc3365c2eb642e585e267cba2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7693ff51624fa40cd72922b99e6da5462c3a71da8622d98dd9af4069b83e330b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bec0a32cbe7d8930ea9c2dced6e30d112794609bdaeb9b8e54bdd351a09aea12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f0a4491ebffa0a8f53b9389c23e9af6866bbe0dc94e7d7d949bac31e56f7b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b85317200dc72f7e0fe2921f111baf047cc7d431c63b76dc17bce2b2db4f4eca"
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
