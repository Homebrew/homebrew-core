class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "fb3a226ab60523777bb2b6dc80f6499bdc7b63e8a7bdcaf449c8eac46a1df6e7"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea9f4467e16f61dfb76359fa7a603dc015a2075ff097347fe816a910fca118d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b232a437efd2421ee49da9c963caa63464ce57fe4692404238094e9b2fc9a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67694e80f98a30dc3966c0985a18e74bb15d4d30c58510fdec5aecc3e4b8106a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6294cb9caefe5c347785f13d05de6ad645344b5ae309f7165bfd4966ab745546"
    sha256 cellar: :any_skip_relocation, ventura:       "afd8c6ecce1ce1ecee1dcf296768cfcab125892dbcfe26d4c000dd7cdb047ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4237600d5041f008b493a54de6e02a3707d8c96d6afc9f3bb914728795b6f6df"
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

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
