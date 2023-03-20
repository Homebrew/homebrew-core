class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.8/traefik-v2.9.8.src.tar.gz"
  sha256 "aae1faa96971888696a6235bfc5bedb81e9290ec2a39a46ad6bee500d029b600"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7d8cffacc643c272ec588e79b86a11be23470f60b83df02aa25a091d5daf11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da7e77b1b8af50a31deddbc95751a0a9bda1f0624fe6d9c3f6b3aa7e177f80b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3701e0078127adcb3073ca1b0f74759584a35002b5f1e7f5824cf841e3e299a"
    sha256 cellar: :any_skip_relocation, ventura:        "e2b32e8aad449ee215f223828efd6db4ef1d11c4ff9b372e4d0b29a92bd19cd1"
    sha256 cellar: :any_skip_relocation, monterey:       "52476132afebfebc50fc8a59fc32154424fbd9adde9d564d33cf7776ae1d751d"
    sha256 cellar: :any_skip_relocation, big_sur:        "896d52f79be577f52c01de069edf526dccd97fa3591a6f7bb9921dced07f1ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cd41994dfdb0f5b97370eadb42b48bf2b9eee183995c16bd272be315a78e8bc"
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
