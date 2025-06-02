class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.118.0.tar.gz"
  sha256 "4cce0ce001866a06510661c8c1df96be3d8c541812a739cec9b36cb2bda238fa"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf9c50f27e8a53c16959ee96b3c10353bb953eb1691b68bc78eaa1285ad1edc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67db638dff071222a5b7d486109cfda50cb894902f56cae11c156182f03703d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce38908b524dfac4488cb86f5729cae974d35bb989e35e79c8ac6f591766823b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9b32193c7e49fcfc65596a801be71732c051ea55a5a57ea21398873d5a9d3c7"
    sha256 cellar: :any_skip_relocation, ventura:       "76d0be92bade498fbb7b0e5637460726ff158ce38eb8325e14321faa1dc91d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "279dd3a3c92aaa72d57af9d957f10c61daffad134f453f18ce835496cb274bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe52a4b9aaf027dc93ee8858a714d8bdccf9f20dd510de2a871a5abb02f7b0fb"
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
