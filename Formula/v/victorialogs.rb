class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.8.0-victorialogs.tar.gz"
  sha256 "4e92eb389e77a573b91ac6679e83c8a2533a9679dca87e956450580f1034e75a"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df99a11cc65d2f3ecc7eacf32c73aca25d4b29e93fe53b69c10b17788a9b9ac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a835fcf40ec8644b7f474c083c4cf9abe0b0d5d41e368aecea78731228c6f43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b311a2681902c863dcc71041fca03747db4e49016c58bb5b8d6c0635f1bcf200"
    sha256 cellar: :any_skip_relocation, sonoma:        "c45c3ff93a05edece214a92df835c80d42e555bbc894939feed08573c52d5aa6"
    sha256 cellar: :any_skip_relocation, ventura:       "6479d74361e46f35ea3595480c3c4bc70668986e365be8a90b1dad2cee493ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "705bdfbf6a402e1a500e48e5b2b2adf06416db2651d8789e7f14d25f2cfbe44f"
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
