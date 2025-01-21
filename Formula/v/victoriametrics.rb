class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.109.1.tar.gz"
  sha256 "349e2b725d19f847b4039d293408f2b357f3b854a0c66fcd84b5fb9d818d827b"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e3eafa59adcab90ddd6050afd699e2ee98f66ad66f41de04da335f5a1c6af44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f2bac863c432ffdec7b07cca9d35c5a9bb7abc9ce67cb6546d701883632af6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d279d359616c8ff7599cf7f4bfa4dd9307bfd40ccbecbbf371e08a904ae68436"
    sha256 cellar: :any_skip_relocation, sonoma:        "a298cfff2249dd35ce9328f620dee18e960bf662216c557fc44a13c64235e3a8"
    sha256 cellar: :any_skip_relocation, ventura:       "defc64107c15e3a31da34022e965cd896e50f2222fa7df5d40bd939433ec788f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9b70c639181e1be5098f3acf8b3d99e3baf24d48b14cd8dc9cfd6f634dac02"
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
