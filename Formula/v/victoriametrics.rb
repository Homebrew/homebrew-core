class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.130.0.tar.gz"
  sha256 "bc83f1aab0c9cdec047919a6a4a1a8d7afb3f73d1153bfc24bb45065ec424c51"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dfd8e76a2d36be0ec9d84c4ecbd272691f3bc2c72da9bc3d07c0057e756e1f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0931afb46b33ae624344795ebe5d5b288c608939981304d18deebc4edb42a0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb534b4812ef255a234722962e8b28962f69afb4798660d8f3c04e8bc06fa3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "028b2cbef01c6ce92124aacd76bd7f07fcf3ea3321f7e38b3179484afe16f4ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c95ecd45a590b926777d698df49e3e5bcb275921b47d0231ab541dc9d35b1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b71e01fdbb4897ac3ec808074111b517bed9161bd2c1c91148e7546c879f21d"
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
