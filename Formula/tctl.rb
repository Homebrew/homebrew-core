class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.9.0.tar.gz"
  sha256 "2b3e73f44741de1b22194a6f0090f8decf7155bffb43a67eb2801357b915b7db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "037b87f990c2080334887878b86e7fcaa379b83d83e4115cd620b51a5aea1aab"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f6094f4ed927978d6ef4f4bd05ff76cee3a7bf7a9edec7d9f23599d70905f5a"
    sha256 cellar: :any_skip_relocation, catalina:      "8a768a1a4e2e4c89da4bbbb3009b301f86955134664891d6815dd55f67bb3db5"
    sha256 cellar: :any_skip_relocation, mojave:        "8eb5c3816dafc62241cfca20aa766492f95d9ac41360f22cae39a295c7fe926b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/tools/cli/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
