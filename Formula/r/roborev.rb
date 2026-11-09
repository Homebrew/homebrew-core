class Roborev < Formula
  desc "Background code review with AI agents"
  homepage "https://roborev.io"
  url "https://github.com/kenn-io/roborev/releases/download/v0.75.0/roborev_0.75.0_source.tar.gz"
  sha256 "b033f52eaa9d03d4bb646e7dee7fee57c0ba2db0145797f3bed311ba6c367bf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da915ae138e36674c4cf35afeb2e0dc09e61f93e4ee6f9ea1953d78f9b8abf08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd5c956e4e3502a2335728e035943de77f9e0f0bc83965d5af51ef100e9d02c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "260183bc598bbec3418154388339e97dde203c36de82d88fb90c79e4c560b7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f26b3b48a03ed87d8b7e9f44641b564c161dae4598c961e01f1eeb9258097748"
    sha256 cellar: :any,                 x86_64_linux:      "9054b7f814b696af87aa266986f92d753cb66828bbbeadb8bfddff94269893ad"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def install
    ldflags = %W[
      -X go.kenn.io/roborev/internal/version.Version=#{version}
      -X go.kenn.io/roborev/internal/version.Distribution=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/roborev"
  end

  service do
    run [opt_bin/"roborev", "daemon", "run"]
    keep_alive true
  end

  test do
    ENV["ROBOREV_DATA_DIR"] = testpath
    (testpath/"config.toml").write "server_addr = \"127.0.0.1:#{free_port}\"\n"

    assert_match "brew upgrade roborev", shell_output("#{bin}/roborev update 2>&1", 1)

    status = JSON.parse(shell_output("#{bin}/roborev status --json"))
    assert_equal true, status["running"]
    assert_path_exists testpath/"reviews.db"
    page = shell_output("curl -fsSL -H 'Accept: text/html' #{status.fetch("web_url")}")
    assert_match 'name="roborev-web-distribution" content="production"', page
  ensure
    system bin/"roborev", "daemon", "stop"
  end
end
