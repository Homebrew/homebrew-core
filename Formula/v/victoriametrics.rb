class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.100.1.tar.gz"
  sha256 "051cf0fa9e86f7957cd1552e06f899bc6d3eab3a8cffe9e41f421f5a4e1b038f"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8491db8fb05c81dd6da394962e970bd3670733e8554a208f5d4e2a0a982bb233"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1d51bd35eae77d7701e4d3f136e9d32c2bbc766fbe9d2cb0060a9c17dd4fb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fafd0db41a79ae9f8993cba9ea7c61914f9a7358c415edcc4a8b5da2e26a7f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "705740a5ee08d43b39569d0fadfc16bc02ba8c6036c7f0779b7853906e9bd6b1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c319d579c5aef59025fa5b39cf7bc645396c78443044cf1c241a0cb92a47699"
    sha256 cellar: :any_skip_relocation, monterey:       "fb0dc4abf29279d5ce36a55e309cbddfc317a924cf1b838bcc1cafb64f656a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39f5522b7926df8128a607f9ef4309d1aafcfc097c56d2789ae4563016b70ac1"
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
