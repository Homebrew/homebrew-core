class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.96.0.tar.gz"
  sha256 "9edca654e1189a961750ce16958e6d58f2362db3586dca57686c2ebe6a8f17de"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb2256232309314ecfaea929b8aa5040bd1d2bc0f5445afe3dc26ea6e48c437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc2f235729f51f518e043eceb04a11ca61825eee4d7a2fffa700e6a15b5eef4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af10a89345735841d2403d820b257d83bb5ccc7e72f3f89698ef4e7d454cb748"
    sha256 cellar: :any_skip_relocation, sonoma:         "a64200deb904ffec90865d0188c5cae5a27d535a6fe48d486aec58a9d294606b"
    sha256 cellar: :any_skip_relocation, ventura:        "ab16dcaec308067760c486743dbd11b2debdb50374fdc94dfc77ba788185ade1"
    sha256 cellar: :any_skip_relocation, monterey:       "dc61819b057cfc76bbc3ba55430d59a17f334fe2b2948ee8821c00ca4fb26c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "919e30259b4f7412451012d704ce96982e9338aeff08fc972472a2cd1c843ae2"
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
