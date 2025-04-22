class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.115.0.tar.gz"
  sha256 "b7efc59b656bcfd09905aa220515adaad99bd3627e56d39bf20a849314f0c7ab"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75577ecec133255d6dcd84e5600bc5c22fd3d682ffca6e2f7e12f25f6ba5f92f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba47f1594f567320a6193845394eb9de4be524361751ff1e4637313fa0ca8b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af4ddc1d59cf171fcbe85d2f3b23e2c7c703760c850ab7dbdb4459f846c9c6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eabd4206d7fc3850e5cf060a320de733c167ab339af0d7351c0edab48050dd3"
    sha256 cellar: :any_skip_relocation, ventura:       "e7c6ab9573b6ae7d88d73e599eee56790526b9d083f2db0798a1ced2485db04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e80ba8e33027842277c8e18b67ddf0213a92fe0d44f95d7e97195a59b669ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b9fa6323b18cddf16ffc64b9300c35d5c7c0bd7598eeb9fc7c73e4f34be7ee"
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
