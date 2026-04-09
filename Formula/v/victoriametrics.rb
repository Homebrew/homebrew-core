class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.139.0.tar.gz"
  sha256 "9e622fa1c59f89bc9b9c8e34cc8d9458eecc30b58961c8aa97012ef08b9bd293"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1268cb14490a0be6e6471629dd30d016739d2829d33c27e69c6d5292faddb72f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a88f67a2c6aab1968bc6a17f1fb7e729c10ad79abdf42c6abf62e8cf5c3e6f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6f176161f544d5652134d046170329f423851ddceef9e83bc0d7fdcd267c9ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "e00bbd58deaf3436b86822f19d8655aec041fe556db271acc37c575ae2d0ed85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3fd0285f3fcc6ed38015cd0d5d216cd2018794177f69e2e12bdd60e0c87d96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad7e4496019881238e64cb9aa560d092995b282f9ef9003abff7f5afe5d1e7a"
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
