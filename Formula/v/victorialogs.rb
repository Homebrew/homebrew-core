class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "73fe43947ad7d4d361da356529c4e8d0ca4990e727bce7bc39e181b1c94348a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4f4d2330dcaa76be70de2759b75d2fa553cd9ea1b6677c435ba925d863fa203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa62a36f4e53d37761c27ba1c56d42ef970b79d93bfc58833f605097e914afd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ebbaf90a38be28ad944d76293eef46770eb6473f8ac40c1ceac44600761d9ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1f8272fd06c2c5125146a1903b70aeae634d4bd4a7054bf2771a4315333363d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6174d10d79ff8c5953a27766ea4bd3832b63a0e087770598d94d8379f01940b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ac6a18a56b31c61993c0a974532c86d2cfae0ef93dec2ec227376e9fcac64e"
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
