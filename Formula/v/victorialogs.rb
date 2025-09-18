class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "b3dcd0ac459f8f88cd71998f1d5f827fd806a9a715d0eb6430eb3485ac635695"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65912ca0c6739e2f857f49c39e222b66fa09b294a3c23280ba7793ab5723c18f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4370f5db599019f34e0c4eaec3724d5f28eb027e0e85fd89ecb7c907408a9690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e45b9ef2d731a9a73f753d2ca2b804dcc4a08224366cac610a13c409e03bba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79bd1ccb70be85fe0d743293fb8921a833a742b4e312ec68e2088513af6c634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d500939b60f85b53b23d3ec1794330f68227ad2a3000ecd4798a361b09d49a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf152a5cd1572398adde98ad61f91af122bda505dcc3ec05c463da5713e14b0"
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
