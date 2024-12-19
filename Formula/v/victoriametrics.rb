class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.108.1.tar.gz"
  sha256 "c8fa5d8d5f1375687ba6af68734feb1938050b8758d02284a2644e320c0d5b3f"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf73a1df440d87527c768f597ac9a89b783e705658002112a7f33936d854d79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31546832646d933b2e093780568d8463bcb602b693ca187ca5dd5790e238277d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a411c6d924a1a8b99457ee08f752e992460e78f93b4aab1e4a2fecedb5cf5297"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecfb22bdf8032abaa2d6935d3c995d1c44959f685c699d1f6c5df02789d2ca73"
    sha256 cellar: :any_skip_relocation, ventura:       "c7282d16f71002c5f5e8182ccfeffdb9bf3f4a22d3761041406c692800b4aed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302a98ac1d8caf118c15c894ecc1519acaa81f31ae20fb2e8442782c10dcbf24"
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

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
