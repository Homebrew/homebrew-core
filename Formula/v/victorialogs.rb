class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "96aead1b1d9b8cc6b2fd46448d9341ac215951e1032a7cd76b9a090eef0daf12"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e3acaa5da4f5c413abee5f5d9eccf03b2de73d188a09cf2e1f1e0ae98e25c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c39fb03be2ea4c8a20be4490b3e86fa6c9d07b2e137502589bb560a6d370cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c2be555c7f5d5385e82dfd55add0c1c4b837d1d0b25d213e6f69e461c78aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f011f10d9cc7eb417c0043ac4f8b21bd47a6c5ed4ca7c71b7622e84ef739979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e619daf07561f00ee3f6c86dd275d0dd9e14bc149fa875d9e42fd466354ed1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862cbd4f3a02199d10f27ff8e0775d2997fccdcb79af92abd1a1152824dfa450"
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
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
