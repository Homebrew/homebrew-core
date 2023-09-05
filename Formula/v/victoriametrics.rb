class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.93.3.tar.gz"
  sha256 "bd534ecdd586543528b90a1b85c4532c79c887183280d7d8d6b4652f6ff18256"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aaa9e4d57297bceca64299ef62f6a3adb9b5a2f30caee9079af34cdf8c86050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e7443836f246f90a527b5b5cf316f5b9a8f5c7a5b7dd605b7527299261ad3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a62d113fc898b15ab95bcedcb6f46ce34cff43e5e75425edd153c83de38f95a"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7bd1b1b476b65e803651ffc0227acdd546e56b4356a49f9527e3c678efd4bd"
    sha256 cellar: :any_skip_relocation, monterey:       "5e8108e3a3c92be4e3adbe1f9478f452430546c0d3680ea8751c3ddec310f2c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "09acad75cd961eea726c6ef6cf38b15be2a8d2343b9c96a8c27fbff0df07e159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6565c2f32a35e551fbd95ab8c35d3c06b5722908e0fb263d3697a713fc3870"
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
