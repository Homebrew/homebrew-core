class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.20.0-victorialogs.tar.gz"
  sha256 "2b845cf70f6c5300a98a50f1607b2df9ecfc51d350aa6f8440ca6c691c4b68b3"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b000d185b0c2723985a6c9f1ab77975209fb8de561e3348f716ab510010b306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753af947118f6a921ca77ce4300f094a47cc9df1b8287bbcd6176511cbb2a05b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "378f264004291918015c277a59f49e1e9921633d8a882a5458db3f6f4eae59fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe4001e53264ee81c70507d767fb21e58f0d2b93f651196c7dd8ad42a22cfdd"
    sha256 cellar: :any_skip_relocation, ventura:       "b7396ec5c7a44a6e9efc55aad01c68285986899fa1056b16c8a319468f3a6e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3de59c06b9bf410b27bc7b66ea5bcd77192e18434db01fe3ee90e3d00147c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92975a273fc13acee5b72d8d88258b9736b3188efec63a8f22c549181ae12a49"
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
