class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.150.0.tar.gz"
  sha256 "0692a0841ddbf8b715f3920a1d1926db541f5db84107361ee1c954fcf9761ba6"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c97a842866cc4e894b445baec4f3c7660b62579dda726bb98e4789d48684b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c95ff55876d334c7e60b11f1c9be31ec23f569ce5e9897dc6554421a5fdb4a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b384640c43e69842a52590c06426d9b8e8f7dd8aaec0711a391d3f4de1be1079"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aec6957a654189ef13dcf8cea2181d01f8127c1a523ebbf0169e19f25f4c0e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2847443c18e3e8deaa6989879f58a7f73be8a066fbe5c9ed51c099516bc449ba"
    sha256 cellar: :any,                 x86_64_linux:  "009deb8c8921eda9a6b13423ae2a80ff6ada7e690aa7b0ca89aa15a15c590003"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
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
