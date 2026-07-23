class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "90d20500b5d9ecc41b0e1c2487696cde8aa16b025a1f2d176d53d759490d8f90"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae78fc273ffb664a6adbb39be74e60f124a1fedd24f4deb0a357c412c5db423f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6720eb26cac690d55db597a74383fe182660da408e966420db98d021d3a0126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac58501f74f980d8a300b0a166b20fc5707d124cfe88016a109711a04f254d92"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7000f6ca996d8b90a44acbe6976ae9e66cd2a2f8bffbbf64baf7021537449f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9c6f7267e5d0e630c135b221d12b993dafa7d831077c809a6ce7bacaac3bcb0"
    sha256 cellar: :any,                 x86_64_linux:  "25acbfd6728bd6382859961185a8b931348b76e72ff42dc6012fb2257957a003"
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
