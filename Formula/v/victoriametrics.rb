class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.105.0.tar.gz"
  sha256 "58c2555d3fde40dd5ced4dfff53726feb1951173018e223f9f28e66fb9127b0e"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e6fed810193549d37155becb7d3fa77098e07e176aa01a99f4a482abf63c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee1b07b8e360a8b8367bcdd375039312bf2ef343e741e00469ed9dfa4ea5d218"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dff30ea32a7d4b0b8b9d802241d77bfeef1599795625b4e9c7ee1e2b78a6a10b"
    sha256 cellar: :any_skip_relocation, sonoma:        "48dcc8e5b42336501b842b5a44d24337a4ff08a4cad2fb72fa032cf3bcd5d1a2"
    sha256 cellar: :any_skip_relocation, ventura:       "b6f87ea7587ee823e76e75517aacbb683cd9582116364cff55c54901f3371ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f975f96881e7adc634eb0e37516a845b1d69f9c7940cfbb8adacdb7c786cb650"
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
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
