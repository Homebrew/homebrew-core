class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "c902b07db5ede9804a60fe1ba648ffbd4cb1843ecd9f2d0ee41d6af7b18f5f57"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48043c00fc7795e50057dc024654cc1fe9a61e53b075e777173bda51d38bc1c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48043c00fc7795e50057dc024654cc1fe9a61e53b075e777173bda51d38bc1c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48043c00fc7795e50057dc024654cc1fe9a61e53b075e777173bda51d38bc1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcd399969f80f060bc6efedb2f2a9d024740337c5cbd530caa8f37510bf33a63"
    sha256 cellar: :any_skip_relocation, ventura:       "dcd399969f80f060bc6efedb2f2a9d024740337c5cbd530caa8f37510bf33a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab732fd3b51f7bbb529b6066ce06d5a0cc6c363ce2fa5156f5d5f39f9fe506a8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable bin/"temporal", "completion"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
