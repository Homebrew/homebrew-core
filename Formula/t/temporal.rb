class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "58097dc4c315ade1d1f338b256dc05b785bb9e413708704605f3f7bacd1de045"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1dfe7e4bcc2f8d0386301b45c4d82d5152e948fc450114bc6dc40610da99009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14cd88aacac4f829d016c6ba2550d463bacf3e20733b49485cad13f540b9cdc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60f7ade57aad9c906efe5b6be0ad89ae409eae55a96e64c986cfa523c53aeae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebca1bfc24f310d0f2157dea1ff4ce7c2a7daf99e08427557f211eaa46a2ac28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93d0f5191e813324e7d639b70ee98ab5460ad0ed39fe852b42aa77506ef37a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b4cf42ec2d1c63509f2846dbb5e9bd2c6a38c438ca787beda562ce65920b80e"
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
