class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "4d1974e3034f9f4a3c3c26f4468e75a174ced21578011e87f3399b865750f414"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e7299380f23db274f0b171da2ba342bbd99e674de1e707588215358b9b803cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb5071958a2ebd25e7105f58ef126e040e8a72894fbce380c38fcd6e5309af90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0bd5517fb55d9776c53855d50b0614386a28d2e4dd7459c8b10d2dd6544fe9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2289a457350e0b5fa74be30f6b7603ea1fb403398985d1eecceb801936a72d76"
    sha256 cellar: :any,                 x86_64_linux:      "4ea76125a96a6ddb8641ceb6eda3ea9b1c4fb03822f1523d618f2bcc0f30f97d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
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
