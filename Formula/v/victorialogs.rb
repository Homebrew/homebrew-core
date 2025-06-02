class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.23.2-victorialogs.tar.gz"
  sha256 "c0688d592dd37b251cc8002a1bb74c8b0268d3da7d8560a0ec02c1a9779971ef"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d079eaf807de01ab084684d2e706f33883991b4bef0d3dca5adb85fc6e54d9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f414ef51b98c0887a47bacc4fa232ae48c17373b4a319a9b54a6f3bbe00092d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db12f7b019cd8c037a594c2ad30b2cdb68a96b4f9c7f438b04a99f2d8acf0e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "323b82037fae9977fabfd0b2e64f6c36b284da915d1d210ba8128053201a8404"
    sha256 cellar: :any_skip_relocation, ventura:       "baf90caf0211144adec931c8187e51cf591ad02abf42aa2f5d48e33f903c4ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06dc45e35bc5c46183461f2abef84b737ef2417b0db0f16fa5c0fb41dd021dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ecf15f4553b18da018ee07e3fd1c22208348e2692bce8ee3652513ba775f27"
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
