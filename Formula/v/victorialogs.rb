class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "4d1974e3034f9f4a3c3c26f4468e75a174ced21578011e87f3399b865750f414"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "339511a643934a76cb133e5c9937958a72b9922516049f8245a65056c0b76bfb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8a36589597de593a53b4bb03d6a86a47fd9e8093cb44b75f8298fa2e63255a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2491aeb40c2519d52dc93ccc86abb5c83ff8528876dc137bf5064e6b8cf79b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97bb5598d20d17abedd7214d6b7552e4cb039d66a2938349c318aeac2b9525fd"
    sha256 cellar: :any,                 x86_64_linux:      "b8edf0fb07ad9f68ccd15af24f95f791e4efd5a4aa5df8e75faec4b10e4ef27a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = spawn bin/"victoria-logs",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-storageDataPath=#{testpath}/victorialogs-data"
    sleep 5
    assert_match "VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
