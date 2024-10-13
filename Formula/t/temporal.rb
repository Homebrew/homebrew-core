class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2d16ffd2f5aa059ceeee85e8c8f98790eabb5cc896a3a52a0cad0d1edb42fe97"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e54698e0c45c57730ac5cb3c59a4c4a755ffad0f8db29aa7258c1780f1fe1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30e54698e0c45c57730ac5cb3c59a4c4a755ffad0f8db29aa7258c1780f1fe1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30e54698e0c45c57730ac5cb3c59a4c4a755ffad0f8db29aa7258c1780f1fe1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "98387c216b8ade4184a3a806a557802a145ef5056b3883274d90e8359b81dbb6"
    sha256 cellar: :any_skip_relocation, ventura:       "98387c216b8ade4184a3a806a557802a145ef5056b3883274d90e8359b81dbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29bb09459affaac761febc8afc4b8e8e5578abda0fe80f55d59cc1f0df588bea"
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
