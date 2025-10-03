class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "fcfe2e857b4e03fad8e63f239df03a21685427f88e0a627c8ac5050ea5908974"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acf8623b3f60ac85be56a956e3ec9fe380f2e45815249ecb3b76de2004a125b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3ab6a979ccbecc4d70b4f992c21d26f98ee4735fe6f4d2fcc31243d60fe8fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa480c69ecd97cb57d503b66f06194927ec57d26c6a31c1ff21fdd7c3beedad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ee908edeb7247b254f6180eb6f5e874c8d1a823dd4d229ec8e7ad88da73bc66"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ae710e94a4cf9d7411aa998c9eaab2616887d4d3006b603e0838734a5e1ec3"
    sha256 cellar: :any_skip_relocation, ventura:       "82442ed6e1f331be954ec61bd2ed6654d606d03b0349794cdbed4e087256dd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd506c2296ee2d9dc1030d994bfc6614362eea028ca02d52245831f62042d409"
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
