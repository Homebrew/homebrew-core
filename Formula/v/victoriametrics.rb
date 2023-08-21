class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.93.0.tar.gz"
  sha256 "34bbd15ebdf6b27e6f2fd59f588cef8f0ef0eaa5b028f19dc92468f3d954c1e8"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061d8905fbcf851bdd46f8fa915337b9822a124921b5754671af781f95f8f935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "044f9793e726912778bddef85c4f68ccb3b8df02a8a528dabcd5f02d46aa84d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69b371bf0b0b60429b26dfa6d0647624005d8bd5c5f70c9b7570b5d8b04391db"
    sha256 cellar: :any_skip_relocation, ventura:        "9e78584449eae9184bd3394b1bbef540f5cf6b3f6d89934ba1c49011c466eafc"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5ecf59739243b04c3362d584f3ce757e72f78cdd1d81998f93b5810b607e97"
    sha256 cellar: :any_skip_relocation, big_sur:        "e030a07c3470c402da56ec9c8b7a4cf8ad478e17dcc05d2de9d2e7188914c73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca9801164fc06f09aaf215850c81267375a2c743f7e2caceb3962240c79f043"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "bin/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    EOS
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

    (testpath/"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    EOS

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 3
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
