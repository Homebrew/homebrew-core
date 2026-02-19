class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "b12c08859c91aebb0c01ac37c46add7411d8bf54b9ed3be7f8b72354e6347fb2"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22dc4278c3de7eaecb6b91d273cab4edb0a8f20bb75b31b1716fb5e8dfbaa7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2598c1c65e04a6240e028a7e89d7daaa03b02f76c374fd4b93ce7ca1f4ea9802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9f33509c85aa870a809f070efb76756334272f70940814e740ad0ae0e1e91da"
    sha256 cellar: :any_skip_relocation, sonoma:        "706f0faa139658313c6334860d6ee72e7f837754ed6ca1b1c16e2350876f9043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c249af0d12b59ac1bcd718c940da9cd546b254e66bdb72facbb0f4da1bb669a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb174822a9b1d84f53a22e624ee4b5b1934d48ceb27aa801227268fdca4d795"
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
