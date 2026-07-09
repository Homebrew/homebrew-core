class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "d28187545061eb41ef36041ef2045d8ea63fd55da9551b60a32bd9cb80f7ce52"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "001a75531ade95e3675b925d569d31277f7dffc8c1971ba0a6ba832167d07676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e873cb7e855fbceaecb5b9048c7525c24b92deb911c2bfebd58079be5cad7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a78bc64ecd956108ce57b3fcc3f8c725532f8bfd17382d675a346f09e0728c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1229dc6855a32938fc61e8577bdae2f6e6dc13ee403597b9954cf2dde96646e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170e2b37f6f91d88bac376c5d1f9e4996a925c311f72b41f77fa0d9a9fae3463"
    sha256 cellar: :any,                 x86_64_linux:  "6da46628df4e4c1efbb70b31a07a5ef2a1481d931605750cd11a04fe9c47348f"
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
