class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.134.0.tar.gz"
  sha256 "83df591a279fe71f8c98c7dd8c71d8d21c6189aee6a85e3f90ed6686c33c40be"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52893fc92b8f88d5c48aa79068e78300dac550c6a283fa36dff82ae39cf67410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc70e362c4a9dea72d411393f17ff3b85911accb93c8a1dba3a8150f58e2f33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dccf615cc2f54cd565e64319f0aabcc5cd03c6197b01672f64d7703e96d268c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "27385a0dfa6012c026fd6130ecd39e12daa0650ac5f57fdefed434a22e54e9fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba45557a788b2b8e40c78627478b3b77135510799ca34f358904e81ee0446240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6843882a29ea204a3e7e6d3594f9cdf6134220dd52f7a94a5281fbdb4065978c"
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
