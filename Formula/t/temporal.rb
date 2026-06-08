class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "a1debb5f6ff517a95ee131538afa605951ba0034c2b3d512ff0239082f1864fa"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75dfdfcfe5052f72bddaaa351347adc26d07f32bc01ceb238ea8a2bccde91e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a859d654ef76641b12d7d8038d7ab9d0cd4e761cbeee7dfcea7d218d29d640a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616168897f93bc2a3397e1a5b327c9f44a0d1e0fb16df57b67d32c9823304adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8082f5db0d3d0030acb669bd8b21a23b47b603fc7d94dd66b909d2d76c0f02b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0639db7bba0e3909e9d0b275bf8d186c20db06719b2a62f6472ba2b7f1f7a06"
    sha256 cellar: :any,                 x86_64_linux:  "5a53b63eba60831abfc8982e2ef3c69922aa31d96c1022624cfca1054de39ed1"
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
