class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.138.0.tar.gz"
  sha256 "a948fc0f4dfaeec01a0df4cae1893f3893e66fd0e73e584ce35075d0338b19af"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b719c05ff52d57450b4d23e70d95a8d0d894db4d8a579412d776c3922c4cd40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0f9099c8637caf52fa89f296bab4771fb309a933878fbf183011f4e7d6a26b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ea3adf30ae3be24cffdd92e8df2229096bcf98a5ebc0143702b329b2c04ac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d505ca5892ee2fb6fa074fba0a5f8ccacbbba59c3639b780a93532efc2162607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "994332610e94d2e159cb8ca48564f0652151b33606344745017382cd5f1a1d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3406974596b0f34f1a93e8e4d45295354ecfd2431329470f64a2f706fd3706"
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
