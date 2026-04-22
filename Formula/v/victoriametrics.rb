class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.140.0.tar.gz"
  sha256 "ae77aaee7206fd1474990048baae78812fb36d12434698b93647f029d1a37d61"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f26288eab3c16cddd87f96ca29adae9132ab426af8fd79be017ab2d9f649fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b1748c49a414bb5ced05c382fc2bb845d370db39510a2bf3245faef65146528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f842ad11de5ad669585e24d5770bcad157d3a01aaf56f0b2c9d1360e25f08fdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f3d7077c6653ecc3da50f5b8145136ad11f8dd55dab7cfde41da92fe1653b35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e98547b9dd432e8e191072db336f3e35cb1e25ad189c4834d6f3f80f11b37f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dae2fff30da59a535546ac16d363e5a044dc1fc8ff7629225ea2209fcedf0d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-metrics"), "./app/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    YAML
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

    (testpath/"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = spawn bin/"victoria-metrics",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-promscrape.config=#{testpath}/scrape.yml",
                "-storageDataPath=#{testpath}/victoriametrics-data"
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
