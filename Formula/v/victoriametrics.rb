class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.133.0.tar.gz"
  sha256 "629aa429705f4a6c86dde1fb62e7a25bf1fc06f5406ae774ceac886544940dff"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea7e16d44acb521611fd420361113c78228b521de2bd7cf5dc189ccb9b25c37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672779f0f9157d41eaba94014596fe0812ea99200db847ed155e5151e40ae9af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4b1266c170849ba6d794e9c734abba103f724c47a9dcb878ea352e1866eb148"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a5e279df24192bb7cf5b683479c954213f8d627757f9f72b391cd21ae391e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9faa5663632591b394fca1adb58799e10076d949378ccae76311bd5b05c79ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4069d95e500178123bda100ba48e76b361eb9c48c2c739301db2193ad730b0d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-metrics"), "./app/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    YAML
  end

  service do
    run [
      opt_bin/"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}/victoriametrics/scrape.yml",
      "-storageDataPath=#{var}/victoriametrics-data",
    ]
    keep_alive false
    log_path var/"log/victoria-metrics.log"
    error_log_path var/"log/victoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath/"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = spawn bin/"victoria-metrics",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-promscrape.config=#{testpath}/scrape.yml",
                "-storageDataPath=#{testpath}/victoriametrics-data"
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
