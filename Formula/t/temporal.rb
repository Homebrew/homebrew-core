class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "7e94dd43b95ca69e9710bed504adf159c60e844c8000fe6bd80470685049a136"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63a8b1bb265b6f7bf9822b8886a668295a976fafa105505630ef05d9e4b2ec34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6500d401bda400de7e3609f769efefb1a3724095729e392d98483e63a1e77d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae6b81b068ded91c1e141699b1c8bbf53c61cd3bca6555781c27468a40aaed31"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf7e94b94e68d02359efd14446b1e75c454eef66a1458769f4c9c6ed28c2e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d4f2c858c7ba52e7104fc82b614c2aabdb7f3029b0596dc5722a1d4e83d38de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c89f0788549a483ed3d6d176e75c940240b0f0d54fa8e2148485496fb136fa"
  end

  depends_on "go" => :build

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-s -w -X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"

    generate_completions_from_executable(bin/"temporal", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
