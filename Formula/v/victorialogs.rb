class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.21.0-victorialogs.tar.gz"
  sha256 "8ab8acc45f722fde1009b0d0fa068560f9b915cd25721b9c54df5b909420db74"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5bdb5133c193663ab871da1ce57d34c21c6e3b8890d786f92fce757c1cfac9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e3ea84b0e6ee2dfc9f97baf4b9d8c871f71d934c60d01281c015d62e87324b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3172f946a12fbd4642cc9d394accb687189f4ed2366a24c0ab915d31f5e14548"
    sha256 cellar: :any_skip_relocation, sonoma:        "973be06ac89303640acd466a757acb09aa7d44cd81c8a10821450155de118639"
    sha256 cellar: :any_skip_relocation, ventura:       "a026930b7d5ad54fea7147e83124bc78d84f21ea6e2e8d0362c242a8b227444c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3076dd6841e1a3868f57a15289944774384aa9be6a74e80a386fa59148339f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632debfab63013a65686df974de450429dc5273f3b96a225507696682ffaf6a2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
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

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
