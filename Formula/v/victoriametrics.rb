class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.98.0.tar.gz"
  sha256 "5b6e9ed8956cc997a0cab812a4f6e0530ec678aaa1f40e694939b10aff2a4d19"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5660554bda4bd01f12a9cf6c79d1d4ad7df17f3f4772e5be275f810c60aa0d1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b34185d568c7006de79308fd113ec6c17e0c847a1f5a7f936e9eef0b0a71be23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c266757d727edca5f483ff27a6a8acb8f8c5a0ba7853ee593dd87fbcf7b484d"
    sha256 cellar: :any_skip_relocation, sonoma:         "91e471bb079982463b32a289d35f5db97bee0bb0aa75b7d0dea6671bc10bb53a"
    sha256 cellar: :any_skip_relocation, ventura:        "d8ad19f73aa56bf6453ac72c242bc287ec272a7f3750560a527101b563ea0693"
    sha256 cellar: :any_skip_relocation, monterey:       "0db67c0250c3df0c3f55393def987acb8fee8044b4a01e29daf9e8a7f21d1ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c1bd6a4120bde2465dc62c4c74c1250a6a27e6bf45c164a960fed4c6838e23"
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
