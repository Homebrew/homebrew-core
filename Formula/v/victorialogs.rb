class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "80bdd76a01250991389dc82c48c4d813c44626bf01bff46f0b0811098c57e129"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "badfb59e1448f29a85d369161783b60dd383f65490f69ef262d41ee5161831aa"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed99611559af133183aa8d3a89e5fb056870c662bd4ac488bfe35ea7d16d2436"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b0c5b049bf4295060be5da9fbde9bbbf96cac80d4754089b2ea3a51b85ed4c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4bfebe55466e1194052f1fd1472161f2effa9532e189770915b3a24d604014d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8ec4aac3e25c361ee96ef61cc39268ed5b5c17262c6a3049dec13d384a9de75"
    sha256 cellar: :any,                 x86_64_linux:      "92407ba2704cc5f80e80723d94235c5e008f81ff17ce12c626da20d27fe4d763"
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

    with_test_process(bin/"victoria-logs",
                      "-httpListenAddr=127.0.0.1:#{http_port}",
                      "-storageDataPath=#{testpath}/victorialogs-data") do
      sleep 5
      assert_match "VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

      assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
    end
  end
end
