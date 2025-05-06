class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.116.0.tar.gz"
  sha256 "8687894f7dcaec6d25e852c40e1edba9d7e2788774f67e99799933b99af2bd5c"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2862dacb5f433be0a8f66aa30383872ecbe3dc78a95c8ca4c40059fcd12c11df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9cd08ea7c864c1751f9277b897867e36f28b8326b9db40359e0e75a83498a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2bb8eaa3a3da7088afbba8d345859a0c4dc5545f5b5f2c42ceda5b00fb9bd51"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71c8d2faa7986793d389995a6129ff758c0b08c12c7a265e8ad525f23b16f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "a50312a488f6e996337e3b54fdf2c1a2b780c14ce8d8e4172380e2f968f73ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b25de8e3e583219f0b4e669ed86a3fe78511eb70e38c74def1a70584d1cf740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6edd13b43a6d1f91b17da0e42217f3e5d1c4f93a3743773c86dbc917be680d"
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
