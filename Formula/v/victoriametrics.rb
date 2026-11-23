class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.157.0.tar.gz"
  sha256 "6d07d13a2ffce44e49fb6ddce61f04aa304c7b3d5b8128b098a9e6e04e3e9ef0"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1c0150e019d90616bf69bf8056c937066d5f74fc04df213411c946aa4b9e4099"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74ebb09070f697adee55691004107c2a70b0553b1d89b8b00370bf025847bc68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02076c32f598dab322b869f1e856c2beab9c17d60deb18de29124ab4096467d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e06e7e7b7207364cf9ac6410702682691812c08bf77968f704439c935e3c69f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4c1b535d867e5c91f53406ec8f350d3be591fd41c66ccf88abe10531bf556fc"
    sha256 cellar: :any,                 x86_64_linux:      "a756b362fad6ef005c2efb0f0581fffc6e3d9e919a3426b0d1619c0f87d4f2b0"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
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

    with_test_process(bin/"victoria-metrics",
                      "-httpListenAddr=127.0.0.1:#{http_port}",
                      "-promscrape.config=#{testpath}/scrape.yml",
                      "-storageDataPath=#{testpath}/victoriametrics-data") do
      sleep 5
      assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

      assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
    end
  end
end
