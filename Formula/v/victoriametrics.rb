class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.143.0.tar.gz"
  sha256 "f369982ed479ba2d1cce26d4d0282e12e4cdef9a9bac5a89dba66f5296c55a6e"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f158f7faba39d20ac1523a658eda5108eb5c337695805c9b52d9ac86e67be3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4cd43146cb40548c34d3440341ff51cb51bcf7e5b59e7cc1171e6ce1c707f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1ea39f36ea665e70b4c42d0d554286813f45311dc2bf48bcb869f60b0e1ada7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d758c6c6dd803fbc2f63d85a2416b1225bc095317214b57967be150b4bc4af22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a089d1cec30b61d44e4634d043a7aaabd6701500ae844a6c8e89ac23043832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3fada9f9a4cf0889160a971cd3889d84aa2fa92f26887ed41ee93d2af79043"
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
