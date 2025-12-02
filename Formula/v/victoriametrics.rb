class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.131.0.tar.gz"
  sha256 "135c782858ae4c67570eb9ef5eb49a9c5eb3dfbcc3b80b43439989753d061151"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "943bb271a4259d510e00dd397bfd32aa61af60fc4801ee4722c3d97ffdcebc4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81602902e24ed03d1cd48c2b6a41abcfd90d30d918a880f94bf7d07a1ff55313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4117133b9be19acfb6c602fc58baa1cfcf7b0b05279427b7ce3184af23d4d68"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26e9792a697230f8a790611995b6ce071901439c505ef045fd9a7f88a906de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e822fafb9774d212a57f7b94461eb21303fe10c9d6b57763bbcebf626f286a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c523a8b57de4752acaa987d3c0afa27393c161d9d0bb152bfb1f90def4eeca"
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
