class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.5.2/traefik-v3.5.2.src.tar.gz"
  sha256 "77ea75c424d8419ccc5d3bf8af614a311b43dbbfe7a9871a14521a419c133327"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fac44e87315858b78675f0702ab34cb3c7836a963d05227db90914c1c0d4661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2221bf91414255332840fe5cd39170429b51697c94682d54d8aa3d2d7c95877a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7b18200a1dcd07fc8d9dff632d1e17182ab8905f163080bda90f0e1251f32a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "000d706974f564b32d467eac72b10f7e3fa2c252d65e6150fbdad6fb6d4dbb27"
    sha256 cellar: :any_skip_relocation, sonoma:        "24e6b66e7158e54e5a84a9730cc0f658463fb404988731c673914397cd676a91"
    sha256 cellar: :any_skip_relocation, ventura:       "b717c1c305cdfff43fe072b74ced2ed7444cd9c562e90f4e6ff413a8484c0a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc8b8753a07385e649480ca460f6a6516a852d298fbd1b610611395a44c7bba0"
  end

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
