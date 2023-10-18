class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.94.0.tar.gz"
  sha256 "919a08c491f71387c8c6a847a08dd265ddff9ec4b967d0e3f20b686f98a7fc9b"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4f336aab95ca048c28eb1a327c06aab2c2ab6ac566660b8df860e6db50725ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ad7b6de09dc4e8e816a825553dafa53e58a39385d8aecbbebac2daad7c85fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d74ca69a1f551112d8156f961be8c371599cbf10d3e5076be615a057b3db185"
    sha256 cellar: :any_skip_relocation, monterey:       "4eda7eccdadac58d78acc1804caee35a42fba6c1e828f5aff529e85b1c48082a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e837c8a9bf4fc0756f3ba1bb9dc9d06c322e727795c4ef7b762581b22b8eac"
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
