class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.10.5/traefik-v2.10.5.src.tar.gz"
  sha256 "5cadd4a5aea784d13c99ded7da9e11c000f48180cf60f75a3c64f22e5b39a53e"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0296b0c5715dd33cb82cafaf573d887ec39544041b76b2ca113b35d34af038cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef38126c9b9757c9cc51e1efe125157310a9d6090d7044dc80ebaaa2d4963d24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb05cb6b8701610a0078579148088eb430f7508a8a921098f07ff458247b051"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d54df0cd26bc47aa1d892ec14660ddb806abe8fdd353e326856ea17e6ad1058"
    sha256 cellar: :any_skip_relocation, ventura:        "7092ab45414d5ac5a512cca33240c703a15bcf9e0a7cefa80e02ed7496932c44"
    sha256 cellar: :any_skip_relocation, monterey:       "5c423bee6c3947fd03505c3bc2c5cbf963b858ce853a528cd27f2c51c9ef9ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "056412ee47dfe3e8e3c7634ca70f015233e2eec9aaf6e69ba79f134f0f145942"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ].join(" ")
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/traefik"
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
      sleep 5
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
