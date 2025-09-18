class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.126.0.tar.gz"
  sha256 "460871ab460183220624df41b4400419e3635615803374c6a8f5844d159e0988"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58314844a4d37096448830885e46f84b2379cd80757b9d695bbe8376904bb31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4385b2143bcb0d537b14a6a9d11f8ad8ac5857cba50a28749f9d1d85862a374d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaa966284f6e5e1229f71e19ef9dab3cf1dd994e786174585cff395ec49e98da"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9a6d5779f9c8cdeca517a380402f65a0255a6368b3bf84ea10769daafeb5f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e7917112022231787340e0c046f8fb660ac23c554ae7aaed5f47cfe392c5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0f8cd7d54492a88d17f075f5d910c4bd5bb58e3752dd9ead55a0236c465716"
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
