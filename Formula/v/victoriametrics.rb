class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.99.0.tar.gz"
  sha256 "06915673039c9fe4951ad2e32f704fcc7c4af924ff566bf95d876befbac43d7d"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90067a9cac0e60eb15ddf42d3bd8c4372efbef9e98f8a6e17ccd6875e0782a0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed9c21011ace7322105e01c920ebfbb5149b87ca0864e73e37fc1b11a396e6aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a2af0faa84468f61dd47d0ff7456639aee4ee1936020d1010f7e49703388c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b61ee1072b62687a7b3a048f89e4c801e8fca317bd64f013d3db94191b4b8566"
    sha256 cellar: :any_skip_relocation, ventura:        "899ccff0f8e3c5af481b4e74ed573c8def88629cf081d3ed2b4e2ea11c0b36b9"
    sha256 cellar: :any_skip_relocation, monterey:       "b8bc933320aa1ca4a98601a6e553824a57fa1f363458206ebb4c4999f1239ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be198e969227a060aceee08dbebee23bb7ef822329047b7e6622943cbcba446"
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
