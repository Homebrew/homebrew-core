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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ad8efc9dca262c16c8c4ffda3d06ac1af20d9fdc4fe9d5b241f68326b0d86c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c03119040865f2aa11e749065a8468bff82caeec6ccfceccd40c301d715d355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6664ed0643376d4ec40be4a668ec6f219d0926a0bd8ced151d9f235fbb396824"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8ccd6a06712d2b45cbae4835505c9e37a749fb6aec4ef49e975303de6b72f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c29d77b848920f2b89b663fbbe31804637adb7faf1e4c0bcc583f29ffb5b63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d00ab544accba16cce43d88c8ef070d1d14acb4da6e3d35c9b477e12b3d4358"
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
