class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "06e582370a74983a12f27999470d13fb0fa9ab31c80cc12f9c23db04256690f2"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bef0f48fddabc4315f2d7eca555e2d60ae798533eec729f6414e353125e9ca8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c87d4a1ea16a9fcc38d6b17a9e1365ac9ffcc5c1d0ec9c7b4a25ec54944ef99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b58726bf01d424cfe979b173d9948c6b563da74ded376d45e2bfb29b343e116"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ce5f8266dbf27f726e45aea89c0050f2a2d16ba4330416e6c0c517b90412d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41604631fff63def154cc282ea5df99ef08788db4b579649bceea04f0624d96"
    sha256 cellar: :any,                 x86_64_linux:  "4e94fb27f99337da2f9d5ec0167549450f69d505cccf024d11e5aa897a4dd150"
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
