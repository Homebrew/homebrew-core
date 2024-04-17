class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.2/traefik-v2.11.2.src.tar.gz"
  sha256 "48a8b8a247991db02d4e3f9aac6db512eaea265d22f0f407ccb038d72d02a106"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7adc3438f44b0651e7a9860a72a238b0fc06d96c86c9c2cb6baaeaa0d6c50aa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf4a2cfa89cae632fad7b5313499fb7cceee216a91202039cd6e078c3ef299e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b838ceda92d2f6cc40fa5f106e586b968217ca51c3daecf74f8455fc29f3dac"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eef486e2b98934be5d9760dd3630f90d6c033288618074c509e2f2c3f355105"
    sha256 cellar: :any_skip_relocation, ventura:        "50272ef783f805a4c4aeb4dd261bfece51574acb2474910d2c335c639d39bddf"
    sha256 cellar: :any_skip_relocation, monterey:       "153df3ebb05cca96aadaeed8dedc2234da9f7b42dcdd6df52096476c12a6c1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23c47320be80bb22abfe03a439f5f2b4a05c1aa116e0924c8ab039a35cfc8d7"
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
