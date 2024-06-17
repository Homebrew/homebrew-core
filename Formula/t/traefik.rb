class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.0.2/traefik-v3.0.2.src.tar.gz"
  sha256 "d14765dee855dc46c97d46a42c60ea345883870f39bb34e353fa1a7b44dd62cc"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a68cd10688e410b12834de3132806f67a3b2b5c9d84241f9f104b3985448c404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6634642b7b21d50c95c99040a1dc38d43b105b5811e6d2f77aa2168878e7bcab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "311bd5712c245b7d270d1174d884c2fdd0b1e66454a896c9308aa32523fe4357"
    sha256 cellar: :any_skip_relocation, sonoma:         "dae806366971d3ea33d53b42f8d36975d1cb212f4abdc46f34c219145ac0814b"
    sha256 cellar: :any_skip_relocation, ventura:        "984ceba227e83fd0686403ec81a477d457ab211850d50040b05cf509911cfbd6"
    sha256 cellar: :any_skip_relocation, monterey:       "423793e8789906ff3f8c643e99446b4b84453dc556acb166a37ccf5476a4d403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc55db7e2be0a3cf749a926953b2fc604075e5f9e99a9df0a696b6362328a6dd"
  end

  depends_on "go" => :build

  def install
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

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

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
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
