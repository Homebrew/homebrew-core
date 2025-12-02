class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "0498d4b91016e91ef0404be5391e8f72ccc8c85d029a1314d4c7d859b2a17819"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea8d09539df0ad5955aa0e551d002bb8c2d2ed8adb5d449d60f1dff0bd0cb987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d038834d40c5c45e0b21e46340a35ab2e7d8b644adf2631e32b7926b15f237eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b52a35b0f73d1abf5aa96f9319d59d7663fdbff65f29388e6572b31ca80dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "75bc4549cf23eedf4f3d139f3d42ba682759861b9886949e9b6678e92a86eb2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1e02f82106073b68bea8623a7bbe3bc777fc1cb9438dd46aad1e1e57d8324cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85712d949a23e883826ba04d42842cf7420dd375950969b5c4f6163fdda3ea3"
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
