class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.88.1.tar.gz"
  sha256 "92803ae61f927b7173e25d4537c429bf3054edfa2f719bafc8fb9fcd411cab87"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    ENV.deparallelize

    system "make", "victoria-metrics"
    bin.install "bin/victoria-metrics"

    (bin/"victoriametrics_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/victoria-metrics $(<#{etc}/victoriametrics.args)
    EOS

    (buildpath/"victoriametrics.args").write <<~EOS
      --promscrape.config=#{etc}/scrape.yml
      --storageDataPath=#{var}/victoriametrics-data
      --retentionPeriod=12
      --httpListenAddr=127.0.0.1:8428
      --graphiteListenAddr=:2003
      --opentsdbListenAddr=:4242
      --influxListenAddr=:8089
      --enableTCP6
    EOS

    (buildpath/"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    EOS
    etc.install "victoriametrics.args", "scrape.yml"
  end

  def caveats
    <<~EOS
      When run from `brew services`, `victoriametrics` is run from
      `victoriametrics_brew_services` and uses the flags in:
        #{etc}/victoriametrics.args
    EOS
  end

  service do
    run [opt_bin/"victoriametrics_brew_services"]
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
      exec bin/"victoria-metrics", "-promscrape.config=#{testpath}/scrape.yml", "-storageDataPath=#{testpath}/victoriametrics-data", "-httpListenAddr=127.0.0.1:#{http_port}"
    end
    sleep 3
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
