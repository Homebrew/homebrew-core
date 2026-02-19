class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "bf7840b6dc54123d3cfe8c326b8bdab5b5f5f079c49dbb50c61e339c6b48cd7b"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f754ecd6d78ab0c3537a311e17d9e711e50b86feea5437992c200afc246e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a3e3c7a6cc28efd0ae1f5c8e84448bd15c089e4d6b38b624db3ec945b564068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eeaa24fc5f98ac66df208f07095ea9aa2de17cfda1bf1ece99f02965ab8b71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "532ee6b38fc4b8444df10b6e9738fb6c791ad071dd973275dcac340a2357f7f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4837c938506ff6554ef36c5cebd995da85a05ec8da25d06bae1e5a37b9774ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a24f96032a5866a5cf57136402de2012d6e1c835c8188121555ef6192cbc1e"
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
