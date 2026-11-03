class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "eb9d85a95da1c391b5b5dfcb4ce6c745a937bbe14155297a60c81c7610d9fa66"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4559cd9f93df839524a83417bd6d17725f2c7b3553346aadc6e6d11e186ed73c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b189e001a6a92744f478d29fd858e26362b56f1782d297f6da78d1c8371c3581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e16d33fcd7780e608fa520a0cd056dcfd9db6552b85a8520b00dbb1f290bca29"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01a3f945e035239abe85a733e4b1c2c7d11492aaac61a0f070996c9a7b37891d"
    sha256 cellar: :any,                 x86_64_linux:      "e9d8771287163b2a35f54e451d4457255b6a1c8a5936051fab6953a54c16e7d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
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
    assert_match version.to_s, shell_output("#{bin}/temporal --version")

    assert_match "failed connecting to Temporal server",
      shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
  end
end
