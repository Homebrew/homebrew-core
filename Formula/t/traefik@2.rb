class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.2/traefik-v2.11.2.src.tar.gz"
  sha256 "48a8b8a247991db02d4e3f9aac6db512eaea265d22f0f407ccb038d72d02a106"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da39e9eae2ed542ba0090a76c55cf9778a5730e13151bbbd2c291c13789f62c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c015e99c800e218ce256f5d8a9d5338a4342b2d7bae18ecc21ef127187a73479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "584a83402912d1265289b07aba88a632e4b25fb9a3ea1f2f6a7897adac0a0755"
    sha256 cellar: :any_skip_relocation, sonoma:         "50b7adf57646b1cfe734bed5f0aa654f5052d2e6528a16a6a8f68c1a6d90927c"
    sha256 cellar: :any_skip_relocation, ventura:        "c73511b81bd712943bf3131204d0ae2aed43289d9441ad6e99f20cfe5fa4ba98"
    sha256 cellar: :any_skip_relocation, monterey:       "360fb734870dfa1d45e3a01400eb294d2f79daa6f3c7f0061c4235891d447842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4096f96667d696b4eb719a91647f372bad82b73eae3717db9f7d1ed8152a1eab"
  end

  keg_only :versioned_formula

  # https://doc.traefik.io/traefik/deprecation/releases/
  disable! date: "2025-04-30", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:, output: bin/"traefik"), "./cmd/traefik"
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
