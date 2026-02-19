class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.136.0.tar.gz"
  sha256 "8b40ec53d043d6b87a9b1b962ebf64093196da5baed99509c7636213b5204b18"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813ebf08a3287d63a9c17a7035c52c14665f52357a8268b3f6649a1a3f0a7114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297775dd3ba53eb42a71e7da5449305c28a270e141f5819816aebc317fd326f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b01f5d0372087dc6a146ce20405ec22babce465634a338aa8afe5ac2344b6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b411f7c9a18cbdaec361543292abe2592745db9cb50ac0da35ad22367c76dbe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7000a0d47ed345e45116c1672a1c89eddc1188218c18edd1205428b7dd70ef5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f172a47e948d09c2327ed8ea65dda96d42ac915216760f774e27d53cee30435c"
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
