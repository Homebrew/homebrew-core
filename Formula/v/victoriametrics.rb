class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.121.0.tar.gz"
  sha256 "6ab33c3c90173d4c38a7a86f5f37628edef7b94a8bf9883abd08cae0d2a6bb38"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c966a4639924f109531686cb2127a9fce0c706103236c7ed3ddd78a40a230f38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00869874290c8ecc168b0649408704a04280fdc6c98492c03c66494958ed559b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea8c7a35ce1e751c104761d9d4e24c1a7b13595a304b1066ab308e70533b60ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb52ff36ea009aff59cceaed91257238616bb03ebd6917b47b53ca9fe139efb9"
    sha256 cellar: :any_skip_relocation, ventura:       "ed05029120b49446458e60bd8e0eb2d4961861ad3cc3bf7ae4111b8494f679d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2ee60ce5e2e165468c62929653bb943b814d9b708c62ff5bcad68a008939d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da1b1fa7850672e4e94396fc6c87213cb58223cf9279999dbe693a51b0a6f5ea"
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
