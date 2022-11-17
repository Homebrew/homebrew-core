class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.5/traefik-v2.9.5.src.tar.gz"
  sha256 "6978ce8c08c566a222a44d31817d4f1d93ecddfed753ea5758ce9c30cb151e52"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5a2c262c706bd3d2761c8fe60c4ffc7687b69e90c5e5e7719b7d2824d6da7d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd884731a752b7decb50819c786db327ae60eda53f1ca57956208e5b6850d889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5713369651a511b0a81a549e5f8005bc40e78e50892b6542d59fdeef41e5adba"
    sha256 cellar: :any_skip_relocation, monterey:       "cf1af085c17d07e4c7a83b929a99e0343d5a9422d3257a32f273ebbf53c278ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "c58ef48b63fe2aed9a428185cb3d89ce28ff017a3df031a5dbfc47684a0fcfe3"
    sha256 cellar: :any_skip_relocation, catalina:       "39d467fd0f4be178c5dd7f3c873f812f947082f32eba861e47ddd276edeae540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c61eb98937cdfec965061fbb56b06c9c708f234f3fd7546a441dedbd42c03e5"
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
