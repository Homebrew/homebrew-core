class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.148.0.tar.gz"
  sha256 "ee14156c2cd6706e9b08d007d4c3057b5ef9adf123c12a76019f35ba1b49a6c9"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "601146c2599fb71e78c6f068eb4cee6fa4632f086fcb90643a5c399aeb041996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4115fa198dad017cf774f662b80005fb84af0bc8ce5072b6ca90dfa23d6f732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a3c87f37621112c411192a1ced11549ce2efd6777b2d7063770f2d123766109"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb4ffe07d6f33e2b81d1d7f9870ca0d17a4775d4782e4dde1e68449d5d612d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51d6f31e1d9842fb8739c5af9fbe1755de3c53f47bdf10be28b638d36639b109"
    sha256 cellar: :any,                 x86_64_linux:  "a58d4132be55a937dec536ea5191c8522485134eec6612327a9cbaa480c57063"
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
