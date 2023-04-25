class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.90.0.tar.gz"
  sha256 "13ab7de804c5d1f1deed52657fff2e454842bd0f469f9c0bbc913c69511f34ed"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27be4acd8aff76bdb5b5265b1e6724ab1ace8306327855c5d54c754fb9927f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bdc8961b4b672fe7a8819a136833c78a55de1fb7e620d8f09481d11d2dc3723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07511aea271e5df252e5caae6c6b9d84b76418a132ae2d012b1f7f2dfc9bffe0"
    sha256 cellar: :any_skip_relocation, ventura:        "93adb8a01ed9107322dbd711217340b983d0da1d8037dd79c32f383ac89963b5"
    sha256 cellar: :any_skip_relocation, monterey:       "009380e85753f1309a901fbb3979cb2ae69a52d2ecd46f70d49517886c012425"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8325b1131f4f4c2eb4ed3131485834b3e25af3fe7b9673532d7c4b8f2333669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c063ceaf1dc5dbf84872d34cb34832a87122214234079b62c0cd5ddae43afda"
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
