class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.8.1.tar.gz"
  sha256 "2a140b1d556c29623e280e85ffe37227a26a27571f084bea8fd1fcfd2ffe5008"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "563c9ec3b2e16f7fbe5c4f9cad919080b7461035cdf7f752d0a4ea49d6f508b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e138f4133c6d0de469abe30f2fd42a997aa4f4a4a90c1cc4785da0c591c501d"
    sha256 cellar: :any_skip_relocation, catalina:      "ca91f3dfcd29e9014eeabb662850e4bfb1c5e337014f6bf251062b8a82767dca"
    sha256 cellar: :any_skip_relocation, mojave:        "896a941808f3d726c39d42a9293127779a2836c89fabd533aa3eb8b2d139558b"
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
