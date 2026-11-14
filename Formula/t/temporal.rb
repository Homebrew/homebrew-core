class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "80e81a40a2da38f6ec13bc61e9cd4dd9441ba865507cd253cf94850538dc9a9a"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "644715afb2425964713dc8aab4f14eff42d2829bcdd8dfd0a406138f3cc16842"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb44f310792d63b00e9614fe635e8dc6c355bb6ae00c5d2379184f5fbe233f55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb033f64c884dd01f37ade1fce53d11614384b6a3c8fca0acb17c3880d956304"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e471dc2735fd3fffabe89648638e41bc6a53320843e1095b56d089522be67211"
    sha256 cellar: :any,                 x86_64_linux:      "b41b77ca8ac275936466adf1e9359b8beae8121478ad420aee900655ba3127cb"
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
