class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "7f0e9ac007df107f6efc05e8ac257642956ec0e04d565bf800ccc3ce62cf70dd"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac60cdba8f3404bdb99f7a3bbffa4b3f87eed42a4d3fa9d25f713e47efe4c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a60f858acca3c426cbbc3c3d44bcf300ff3c21d07d0a4283f98e4f0599b2df8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e2e9e9b71dc15b45e9ac6e4793d92c1b10b9437c6ba841155e7b0b5495cc184"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8d2fe89d770ac803683188b1bccd3271c2499c5e4024db263d1c486b5b11c54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba07ab189d087b8a6580c0897b463369f6ecf7903920e252cc063fc101cfc3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1207471e6b15856c80c00e392bab6217dddbe5ca26a689435446e2e061d085cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable bin/"temporal", "completion"
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
