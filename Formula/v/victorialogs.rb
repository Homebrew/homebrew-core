class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.7.0-victorialogs.tar.gz"
  sha256 "f17f78a4789f06fdf12e182c292bc1c4d6823e6b9d81bde2b8fe2cd43bb5a2c3"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89fc264ee68b77c62dcc2d6c6778926d164961d1ffcaa880776ab95eb6edebb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f26ec3e878251c8cf052a3eea71f7a17cc8f9c1cac4777eeb83cbcdcb9d23379"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baf7363a87074522b55e0b419d8d0c65d5a04f0f5e3d54b594f2f6ba2479408f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9d3cbad5b31bad7e961ec7799619f5f6be882f89ac41d561a881ec9378ff2b2"
    sha256 cellar: :any_skip_relocation, ventura:       "2e1472c6d2c8bfd7ec9d69fc451779e3c342c6ed6bfa9992c658907cfd6c21db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65231827df934b0005de406fa96051f63d2de6513e13bf9a15aadb6ddafc17aa"
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
