class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "9b8c3250a1dd4c336753392baa9884301b741b3c37cab536cc4639b6117ad207"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03037721773835862851604eaeb89f8ed2179086e6e8cef91faee6f553f75cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d42e917dafedc3839b6792d05d65fccf763991968f1c045ca726357e8810ddf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7e72ff0ebed343b23544602982bd1828c815c3219c887571bd942ff10654ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "88e6a8e686f47d3ff757895179bbef4c627e46f47978dd70d80a37b44e0fe064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f43cc8c5e61cf27bf8e9936307fd060416e7181f6d8a8c20f201f83b8caa143e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb59eb2c13ad8b4380e4f4c76ce3f9c434f4a1ae8ae56f7b0fbdfd63cf5c0e4"
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
