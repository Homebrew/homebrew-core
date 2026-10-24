class Roborev < Formula
  desc "Background code review with AI agents"
  homepage "https://roborev.io"
  url "https://github.com/kenn-io/roborev/releases/download/v0.73.0/roborev_0.73.0_source.tar.gz"
  sha256 "46e743f69f88694995029caf4fd8ad05b18430507ce76a8607e9d8340a47b97d"
  license "MIT"

  depends_on "go" => :build

  allow_network_access! :test

  def install
    # Updates are managed by Homebrew.
    inreplace "cmd/roborev/main.go", "rootCmd.AddCommand(updateCmd())", ""
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X go.kenn.io/roborev/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/roborev"
  end

  service do
    run [opt_bin/"roborev", "daemon", "run"]
    keep_alive true
  end

  test do
    ENV["ROBOREV_DATA_DIR"] = testpath
    (testpath/"config.toml").write "server_addr = \"127.0.0.1:#{free_port}\"\n"

    status = JSON.parse(shell_output("#{bin}/roborev status --json"))
    assert_equal true, status["running"]
    assert_path_exists testpath/"reviews.db"
    page = shell_output("curl -fsSL -H 'Accept: text/html' #{status.fetch("web_url")}")
    assert_match 'name="roborev-web-distribution" content="production"', page
  ensure
    system bin/"roborev", "daemon", "stop"
  end
end
