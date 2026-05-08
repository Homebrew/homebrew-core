class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.142.0.tar.gz"
  sha256 "49c5af17d82e8a32b829ecdd0da5ae48f09b0b61273010cce2f2236dbaf0b675"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3abeec7dc3d71a63c4f920316f87d7932056d0852c9ba1db7b2aec00286a456a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "055eb151c901012048b90bd9db208f7a01bd1f7561427ab0aa4a597133b9ab49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83b2a3d72f510d7c44237e1472f3a06a62b8863a3f3c139b9ee63ab6af881d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1fe654056a6e74ea2e981830398002f910e05be3c2fd2f9d95966e9bbf2ecb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436ebffbfc23fe60c55d6d5ab2e9c26e88a56de8f0de44358791990c070af9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cee98f2b15b14d1dbb599fe00ea422490d91a867cd7e56a5399ed4bca3fb092"
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
