class Roborev < Formula
  desc "Background code review with AI agents"
  homepage "https://roborev.io"
  url "https://github.com/kenn-io/roborev/releases/download/v0.75.0/roborev_0.75.0_source.tar.gz"
  sha256 "b033f52eaa9d03d4bb646e7dee7fee57c0ba2db0145797f3bed311ba6c367bf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fbe413c5d17b197beb98ea358883d3ca9744a7a6c34a3be7736412a9f9e29a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d3614ea7fedbd6f2e76b69a9511134ecee323f1f60d8df291074608a6d01ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42d02ea456058f908cd22a74417196a6626a992fa39e695b69f1370183196ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "245bdf945e32aab0357d3ddeceba1dba03872fddaa5ba826e650a0c718ae9567"
    sha256 cellar: :any,                 x86_64_linux:      "b3217f7295f712b10e13098946dbf6b76abd5dfe0baaeaf686b3eb88e442c0a3"
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
