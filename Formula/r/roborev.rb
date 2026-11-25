class Roborev < Formula
  desc "Background code review with AI agents"
  homepage "https://roborev.io"
  url "https://github.com/kenn-io/roborev/releases/download/v0.76.0/roborev_0.76.0_source.tar.gz"
  sha256 "ab4bad18702c654a913d4672e0c8829ac55bd3ace8956bd41f2739e0a335afd1"
  license "MIT"

  bottle do
    manifest_sha256 "b25033d10c7c8fe3bd923f4692c1be529b03e618f85594027ef734f417f63f5e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cb85c708bf5220751c6ec61a8e45fe010c107d021510c96339af9c60dbf9aa2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "042f995d6bdb15085dbfa673aa3b2f39801bce86c6550c2a03741aef28da9262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05220c0f6e92dcfe67506434c97cde6fa0ee4b93355c0e82e6564cc42528b8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d19d3d6e5cca9082a4d015bee0473b9ff4f1e85d757546501906b487c1444812"
    sha256 cellar: :any,                 x86_64_linux:      "bbc24ccb35fe418f81ab5877e114a36588b364b7c3055bf4f18bee6af7f76b1a"
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
