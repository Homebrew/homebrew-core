class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.2.tar.gz"
  sha256 "dc85709dc7407828ced5a7fbf8a03e62b1a97f1dd3652f4df4233ad715e34585"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "099fd3f17ed5dc2b212cb056c84abd25410cd44dd965ccc918564d7850fedf3e"
    sha256 cellar: :any_skip_relocation, big_sur:       "1605ceaaab47a29f6f3d62255a1fe2e71f872fe0a991a766e80bf47e8146af3c"
    sha256 cellar: :any_skip_relocation, catalina:      "3b1b866985c070952cec1bce7b430f00411e5a51ebde8740ddd71dc9110a7282"
    sha256 cellar: :any_skip_relocation, mojave:        "da94b6283f3138470c32c70c2eee5cef2e46748069585b9722d2b7d890cd2829"
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
