class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.146.0.tar.gz"
  sha256 "d2ef1bf879129901943d8236134d4e97923371c0da4d752ab1a72f4b8a53f243"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4358af2eaa445346b4fedcc855d4d65d73bff6df05a77d536b424473dd99cbcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9efb3ae0b1050399c813c0147f016220c50742a2760f7dd4c26e8ac888724d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80a096de58e67af2f2316e93245b3e68abe2f5e5a8715c2e710ac781942c0ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "af3e90cb6e7e494c751c3ef1f45fa9e3b75fc2f2054465c8566fef13e970319c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bb7cb58cb1396bec4d03424f32e259361c4ec529dcdb4a963aba760e2117dcf"
    sha256 cellar: :any,                 x86_64_linux:  "f6c8a8e08d3a559667011f5d3fd657e7d649fdc4e763bcc75bb6cc3ae13a3295"
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
