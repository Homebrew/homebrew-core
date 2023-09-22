class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.93.5.tar.gz"
  sha256 "0e1a706cf47abb5ece551f6668c27873ad14149a9f9851832e1318f5fd46cce4"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4970f349dd10ccde08a70ec686c9f3266f659b0c6d852d35c58ba48aa31541cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deebffac8c59c3de989df2517101d7efcc558c40ea78f4380d9f0d403aff867f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e21bbfde166208a8035a4f8a2f3bc0026a6c92e13de16998b0bb5ec560458a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091a6041401cc9f0fc75c5048abc168117574a1a2a992146746131da31672d6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ed4df6dbe2c69223cb14236cba16fad03f653d8fe95e5baeb8e0154b9a55799"
    sha256 cellar: :any_skip_relocation, ventura:        "d32113fa04da5ef3df57a1427b338c8404a09bbac990a7c958f7864920f0de62"
    sha256 cellar: :any_skip_relocation, monterey:       "6591f16048d6ed49cbb77116c104ccd986cefe6504d512b27589928543912d99"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc5b39a919fd3e729e74078230afc2bb87955cd10f871db74354f19e9725565c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375613bc2815cc8e5e9e3a3bf2a1b4ceb2dbbe395380d4b96d4869419bbbc324"
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
