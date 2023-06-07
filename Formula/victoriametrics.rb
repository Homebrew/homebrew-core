class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.91.2.tar.gz"
  sha256 "b137482b2e7c9054852ebbc06bacf0f022fd331ec9ca7d924da66c61b237a7dd"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c379c9063f8ddd199584aea4502f0f21e374215ac17659700977ff0af752bf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d46db410bd03980cd71604a812e8981ccc9bf601a04929f3b09e792be33fd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4b4e50d4d746acd29ed61b7f78b2956aa9c28fbb17e34c7fcb4de569da94a87"
    sha256 cellar: :any_skip_relocation, ventura:        "bd322030eab6c06d7a8162474b18ee000f03b84f138b6030af58ee9fcfd52e49"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc03802f6ab8ee2e3579a2a9ad5761d2ff7a4078f024c49615c6088bfa7a0bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "87583009d12a6c92ea0fa089bf8e4936704d056cd92d41d7c4c130161ec9ea57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8369f12347859c5a054b9ed4d1a93c2d59ed4c69e14943f916fad9a93d32f7"
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
