class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.18.0-victorialogs.tar.gz"
  sha256 "2fc4458044ce84c9b18aa7d9313478c4a0144e9cb6a587e9b4f0d6fb0be34c67"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]victorialogs$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d30ece0aab9649829fbce4df820399e32f86faa5cda65f426e210af33006f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6826fdd5a650c8e6be810e94e5ff4598ada588bfb24c214af4dd8bf34d99b6b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ce1446767cd3d8f1397974a0de3159e1d11f4e4e804b3df152a94a4491b0e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "5be365d9c798987cbeeb4526b3a0ff07865f199c476b9de4b282e73a83490381"
    sha256 cellar: :any_skip_relocation, ventura:       "465a405b0deb76d5fad90efabc7b76a07a8a700191ce93a1ec5aec272ddef7aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e5c742716754fa5bcd2b1f429ce5e700dd0201110143a00cf76af12716d9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0f44812825a3c33d132d4f01f7d64c77bc93d377013cad737c6cfcb2fb0e9d"
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
