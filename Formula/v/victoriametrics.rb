class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.101.0.tar.gz"
  sha256 "2807b6507d40d66e8e33e4535d52d1b45e5fa081eb58e326e8b82905d3aaa4c9"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4394ec7bf29b085ee2bcb284ae0dd1c363905153a974fbf67f2e33e3f55c8810"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce3ab84ff9c14098d6a07d259653385e5dca1d93a1281265e93b0ce3f39831ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c411eb3bd290d439bdcda67e94b9ac5ee52a4cd07ff144d5415d28fdbfaac757"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d810b2298c6b60d9e386267372839497074874fd8851479091020d39807ff8e"
    sha256 cellar: :any_skip_relocation, ventura:        "a3fc4db29f2e32680360681b6f3a40473842b6512b34b13ef1a896b8fe99e081"
    sha256 cellar: :any_skip_relocation, monterey:       "3e941611507afa05e37ecc1db2259fd6de88d188c96ddb972974e0e3a7625e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4db374efa2aff3c777a56788caf43c831afdacb9ae705e4b7e9d07880248d08"
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
