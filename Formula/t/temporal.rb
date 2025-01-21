class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "859c5d71ac3c385121be2119a59bea79dd8edcd6cff3e0f70d71bae42c140360"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b061d5fcaf71cb788313efbcad34b72f9b6b8524dccabaa815c8a19f9df05b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b061d5fcaf71cb788313efbcad34b72f9b6b8524dccabaa815c8a19f9df05b5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b061d5fcaf71cb788313efbcad34b72f9b6b8524dccabaa815c8a19f9df05b5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "55b5d9ac30cd5a3a4addb1f112da3e11e03e79c9b699017481ae51b36c27ac3d"
    sha256 cellar: :any_skip_relocation, ventura:       "55b5d9ac30cd5a3a4addb1f112da3e11e03e79c9b699017481ae51b36c27ac3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30fb2444eff599d50b2584d819babcd989e932eb2913974c2cb99ab63fd59c44"
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
