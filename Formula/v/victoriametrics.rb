class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.125.1.tar.gz"
  sha256 "14d079026d5051ce33953ac7b5593570bf6809448ee2acc4d82cc8df99d674ac"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f7f631135d8ffacf07b8ca9dcea934fc01272389876c896e0532609424f30b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55692201c3c0fd348cbd3459e686a1445a5b8c06eee37372b664d9743e8ac06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe7b60c5582048cceb534cf7579661be0d1c3e1adbf7ddbb730c302335c3d604"
    sha256 cellar: :any_skip_relocation, sonoma:        "11efda8b20cf740cfe0046bf6f106ad82f1f87dceec1115fbf9d44f1e89f8287"
    sha256 cellar: :any_skip_relocation, ventura:       "e54ec6fbb79f0d71ec6fcc67668bde0a47b6b8b6757c3112c80191765ccbb6b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a3719b0195265d3874e1f2f70d7089f0c4df629c26670948256dd876f5fa49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4243987c3f4eadd3197d51f042ed1183017fc4ab695693783bebe4c999b348"
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
