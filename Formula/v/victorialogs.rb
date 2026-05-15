class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "f4556589438f23d29ffae5a05784d622e8801a789324bc43e184360302a207bd"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "119c6a82769954c63729626101fe056155a9c41669b6a1d398586681d789fd20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784446e03b3503db7c5e86c8a5a1a94bca696029ec3055f9c8070668b5857706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c616054dd9bcc38fb0229e18ac3a55734ab1047db609ce97b38078e3b802d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7451c31d5dc8498e0f7bb8bee08cff0009224b539dd0216b7bd5b239987293de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8082b8ff24de63dbbfc420aa097c2e414df1e0b52a5be42ebb3a62da4e67b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a382e4afece52d57e68e9ee37d73a82114c27c3cab2e9d328e7bc295aba02503"
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

    pid = spawn bin/"victoria-logs",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-storageDataPath=#{testpath}/victorialogs-data"
    sleep 5
    assert_match "VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
