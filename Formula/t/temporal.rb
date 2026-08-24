class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "b54917441b43fb17634b862a1966337fc129a927290eb45a86cca85e96bea086"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fad2c7328d8ecc52d2a570779009b388286e7e5c0f785c6ac9506bf3361e9598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a267c93e585a18f88c4c96cc354aa96a7db8d51fcf96b97b714b8c325eece3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d7a6b1b5a1ef2181d6014ec4f34802af652f175c537ef88ae94cec64121e5a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f803b92f4299b34c9b20eaef66ae87e9aea59af35df9b92782c0bd742c3eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daeb62902add2668c46ab8d94283e146dc89f778955685d176b687649d162e8d"
    sha256 cellar: :any,                 x86_64_linux:  "2978f72e2d0833a73328055c47b99d51abbe230be82c47fdb436d0be7a79c53d"
  end

  depends_on "go" => :build

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
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
