class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.144.0.tar.gz"
  sha256 "d5dd233d29a761c958d59ee071addbf41ea38385c40f0dfc8a6decb58f52c467"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae47fe1938a1e0e1dd70a998a82419dd4b5396abc1178ee3e45d088d420c4198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ce1d77d3ee74aa9954738ac6a87a2ce427d4820e68b761398bab216afc2b901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42224357f1ca2c35cb47a8ebf8c8aebb36467c94dbe04043045a26a1b8072882"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdfcfe2eb9ff4b8d7198f0083eb64a933e32c38e437b00815a9498e915621428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698cc0da9ae57d5c563cc4392360cea2b2230f7b93807347fcdefa8578e3d2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95fb3801670eb68b2e723fefc8376e062916d1f864430d466db31bcb4fc566e5"
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
