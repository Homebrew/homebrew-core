class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.7.0.tar.gz"
  sha256 "5b0ec2ff58b5fade97d78157d6ca842a2380374cea2f2c3ab2609a98124cee8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e9292326f0fcfedf9f8cb741215894982295d3b38a11e8fd3fd04ac2eba42f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c3240d699df205ac4013b5d872126a41b16b8b4704872ee0b300d349f7a2f9c"
    sha256 cellar: :any_skip_relocation, catalina:      "09c16086c9ff85c4aeab4b8bd5951f0d8eb79eab50944f4d02a3414dd04590ae"
    sha256 cellar: :any_skip_relocation, mojave:        "f208cc35c3b28703c7c81afa0542dcebe68a2fadd20defb1a4feee12ec9f54c6"
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
