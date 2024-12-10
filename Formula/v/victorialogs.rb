class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.3.2-victorialogs.tar.gz"
  sha256 "efefc27abbab85dd3126201665a28fca04cf14250fb34e9a1bf93b1715382972"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)-victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f993469522f2a7a0fd1abb986d470a602d1f4569be6105eedfbe27f36dd4edd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b011d5f2c4fd54b2a82d575e4cdae11e96195b4d6c264a03eb13b77c05ffbde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39f479e84616b159204fe0fc5badd83cf870559e360d64d85618c30afb41edf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "107826181de84e8bd0ee9ea2bf5e1863b80ae7fdd32500c80f723bb417835e27"
    sha256 cellar: :any_skip_relocation, ventura:       "bf4ad08cd17c5cc9d7cd0bea0bd9901d910be6dda84f9be58bac1a533ca731dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03ace0efc347dc3007ab08c4edb6a58b840c9cccda43002de6c582bfd7377d2e"
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
