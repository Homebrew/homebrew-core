class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.11.3.tar.gz"
  sha256 "2d41a6ff696c4ee007df39cce5f40fde57b0e1becdb66c88f4a4ca689a933d99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "516d5e2e9605e4c8da774f9562f6a99a940d4c03d8211912427b80709e07a297"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b3fefdd97a8727bea0d78958b308a208fbcaf5f7c40ed03902867d9af5025c7"
    sha256 cellar: :any_skip_relocation, catalina:      "3cff533957b78764f56281d7aebb9fc1393b0c1a2dccf7b715a38b0eecf5a24a"
    sha256 cellar: :any_skip_relocation, mojave:        "f18d10d722c6f80df42ad7b7d9de60f9b274f4ab27254e96b44428f6871970fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa3eca6063544f12eaed4f7d9b47308b8b47ffb3ee47a8b8edca7827b3fb1c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tools/cli/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/tools/cli/plugins/authorization/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
