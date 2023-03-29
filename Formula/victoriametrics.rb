class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.89.1.tar.gz"
  sha256 "3c090a8ce399452322ac1718c4bfd878a46c1f17366c0db2587d95cd915c8fd4"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fb47f99a11c3a70f44ae57d39e644f21801ad569d21bd6257801ec934f9e9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcf18729329c6c69532b0bd585bdccc51d754025cab6819c7354bf3278cc390d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9818465bde2bcba85c1f6f4867ffd19c5e2a4439fe080df03a4d0cff15c6a00f"
    sha256 cellar: :any_skip_relocation, ventura:        "81154b850b33b9138e56771e1d54b72d2d261b75a3772dde429639cd18d78dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "502b9491e926ee05e74bc982f7894f970fbc4a38540f2f4c9133e629487421fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "616b59d7d55a1d61bc28a63ae7bc1535a4041d7b6a22ca07b0f17ffe879d6f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60403d5fa1da47e9436bb188cb11c6f8393ba11b398df4b3623adc8b367b3720"
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
