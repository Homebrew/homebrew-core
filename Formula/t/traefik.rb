class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.0.0/traefik-v3.0.0.src.tar.gz"
  sha256 "6445c42c073c2d6e0314083b98bbdbb8510d4c8a792278e8b55dfb4aa25b3c7b"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da5f7fd5d4e47fd22bd8fddf5c3413b9c96752f74a6c5975406aec80542efd62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5307ec70ecd330df9e417176f38049639ecbda5f87344658f77bd46ff83b4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ed31206b62ea66efb5f72e6d92eec7266079c6220c0e418fa938b05f76276d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8090a90e2ade3e628dd4d25a8793773a262f790f23ac37f8534cc5b98f1c1b4"
    sha256 cellar: :any_skip_relocation, ventura:        "81e16deee020fa95cda3065f725ec8e43cbf5ead07bc5033a9ea4891888a125b"
    sha256 cellar: :any_skip_relocation, monterey:       "3aaab26048462510269059cb24cdff6d96bdb0bc2a68735ad2d56d7649e4bbea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76ef44e89c40a8eb2369f84c17d69066aa7c0e9099099492f67a329bdfdf737"
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
