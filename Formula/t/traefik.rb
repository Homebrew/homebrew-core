class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.1/traefik-v3.7.1.src.tar.gz"
  sha256 "8d6e5b7bae2b255e42f0ff3a8cf3c7eb02e1a29778931e67d7b2cde1759336f5"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc4c2891ce0d38f60b45d885e7606516a8fd89d227ba3012d16d0dfe34993cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395a599b9d0f8971c8e86e1da3a38085bbc2999c0797ff3558160acb7f7d53f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c1a8db5a548c46a527f57438208a819c8d380628ee57a23af8d02ac15438f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb2955c733c3c01ab2ccf4e8d4116e8d8196de7dc3c7c68a74d2b7a22ecbf666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de740a85fb961f9c3c744a5dcb69d2575ecdff80b1d1ad92d17bba401db6cb79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55787a478fa11d621e0d8e500454cbb3e98d626b748554c78647a4c422080b7"
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
