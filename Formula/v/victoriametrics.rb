class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.147.0.tar.gz"
  sha256 "ba2ed50f168865c037edf288cde023e23db67937d934faef85db9ce45d660e12"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bf38c512ec9ae5035b9403c56b98d75e66471170728757c9341458773eec1ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20869c6edf46ba3922488293ee2cacf10be66c6c85ece5f829920a2cca4c2e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03724520c929986c03082f10981bc6b514e70e29a1ef58528da9bffddb6e8d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9976f874e51154ca2a4e15936132060d2d5a8537b92d26aedd62811b0607039f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05075e06ddd7d427743611881abfacbaa2760bce3a0bc71d3517e9dc8077beeb"
    sha256 cellar: :any,                 x86_64_linux:  "3391fe3063d00de3050434296eb09bed85387322bbacec643528a3f7c3219cc4"
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
