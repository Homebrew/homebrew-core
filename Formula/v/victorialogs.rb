class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "a691ecc152ef2da16b076ad29c3fb3cf5be2ca2cf413e1c03040f26eb64b0a1d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29bd3b81ddeca60d2104e57415f6008367d1f15076ec1ba5a677bf4c28a39dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "410e5b16f0000210ade18bcad76f9fe77ef1b44abf1decb7dec72de49fa958bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b598d91df0a7933abd7bf085a762a537f219fcf7d8a4d8f315a54797bad795"
    sha256 cellar: :any_skip_relocation, sonoma:        "db9cfedb543783d2b45e8a6e2c16c3dda40ddcc910955792287c38945f23f453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e31d306bc47d9137535d2e3c309a1133cf808b7ddce69b85d3ef3cc1154da86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e72b09aea2ad1205e279f9dee56511cca9a3c3b4c57d81b40958c4a1f3ce4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
