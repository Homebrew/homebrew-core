class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "83d19b97e0f10c734c025dcc0715779067c6e14a405d117ac4a5f1bb9e82527b"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31ecad0072a20fee5542c1eca87945297b806dce341d1aa9357dda26eee4edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e7d6c482c886d34be4f77c35c8565c53820d3fdcaf5488b911dd21e0cda4a34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74c70cd0fab52ae62b61c34a50703e6d209ae9af9228636da183e8aaf620e4cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "27ae33a6ecb1fa9643e31ba9f17b583272e4ea046bf15f4ba138860d9026d52f"
    sha256 cellar: :any_skip_relocation, ventura:       "d4fec8480603552902a6c09b68620e1616ede73eac366783c6e645e689a6dc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded7a6d5d48072ffa5e3d4da3c668b818dc1591dde7055cf482abfa0b1d6e89e"
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
