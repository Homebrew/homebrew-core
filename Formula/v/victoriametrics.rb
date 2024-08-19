class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.102.1.tar.gz"
  sha256 "57677bb7f85b3ae1278210ee5a480c5bb0834bfbb1c128e6340b6f6802916ecb"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d84862175c2bbc6fa18dd8b1e5228f3cf037ed4f4d125037216c4bcabdb04934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eab0abda227ed96141da6a67926c2e8893935432c835c23e39ff6d3dc239bab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b6725547d7db8a80e09adc72160b5b8e6cb5a0ef8e01a5ad1fc1537e04d2b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eba05c4c17ada489f62a181d40703b113c8677f65a22dd2e3efd5e31680c638"
    sha256 cellar: :any_skip_relocation, ventura:        "4828e069eba96634dad6dea027e7c33f73837563c1456ce0af861c35f6629236"
    sha256 cellar: :any_skip_relocation, monterey:       "16f1f355eea7f6c9c37f616448cf385019648b651a7b7301edc50cac92b9fb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7316e64eff34f336c72b16034e4deecac74959eebd9e4b99e1cf3b1d0c1d696"
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
