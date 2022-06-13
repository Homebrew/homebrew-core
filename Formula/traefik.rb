class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.7.1/traefik-v2.7.1.src.tar.gz"
  sha256 "23b6e4dc5c21c787ebefaae4a15046d19608fbb000a983ae0a1bfd2e1bbbcdf0"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d714e902c3026346b35098f23eb423f230928e5757c384ff0872307923e762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d7369a52ee3a182f5ad23cce8476b82451b5b9b174d7759009387d143483dda"
    sha256 cellar: :any_skip_relocation, monterey:       "5b6da436ae555fb864c24724bc84075a419fc506cbc46cf49dbdf4898d25936a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cd072d68e58486a2870d47dc0f52f2f0e64f68b373ebcfbff7e8204ed99227d"
    sha256 cellar: :any_skip_relocation, catalina:       "db217f09ad8944f1e3480b9035ca4d770f77b7c920eb81be21b53b24d7a5130d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd18784f07215e83c74b81f32f81c1832dd227bd126b5caa9d68cb8734e84e0"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

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
