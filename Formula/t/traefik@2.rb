class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.6/traefik-v2.11.6.src.tar.gz"
  sha256 "0c3c39b7f4a9884fbbaa4fbed264b13bcb5c9acc6e3070e0395b487b753d32ee"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c76dcba1e58d6f16c9e920c5bf139e8623e662962065e25f325ef4895d65f18f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c452e57e594370ae2f4b4e6d8d555cd337c9e9734ab83ac4e1b04dfeb86c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b958add6738d4d0eb882f140b8d8b48a278b6409e06390493444e285ff707254"
    sha256 cellar: :any_skip_relocation, sonoma:         "45de45afae474a88690168d797ba4c959001f289553e80730076412a448f8791"
    sha256 cellar: :any_skip_relocation, ventura:        "2d711baa9fbc5bade8b48b900b63dd634d9dd9c118dce66e854c7ff33a118499"
    sha256 cellar: :any_skip_relocation, monterey:       "718c865a38d167dbb54c73e096975f6e4f1a8274d7f63f8286f856e8d6f2a872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44c3fdb464796c483d03eb628af5d1f12e3f0b7f4f8233ff6ad8841df96d65d"
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
