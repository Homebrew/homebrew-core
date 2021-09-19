class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.12.1.tar.gz"
  sha256 "6a7ebadb051e4e3b7bec0014242c7ed5973642521c5b34937039b55a0310ddba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "972090fbc59fb85d57eca32124964f26f39d0d3d775dfcbb0341ddb77f6c3bba"
    sha256 cellar: :any_skip_relocation, big_sur:       "3da365b072b853b2fafdcbc7084cb51bda45b61f8837cd37df7f5b2f777b61b0"
    sha256 cellar: :any_skip_relocation, catalina:      "720bbf5a11c6b1cb7f18bb5aafaa3bef63b5f21097bb18527d53ffc1ac5abf49"
    sha256 cellar: :any_skip_relocation, mojave:        "8cd8cbe74a806c4e61b4a80b43d66614101496302caa022131c2c37d00733c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44450958a77382cdb84f9f87b1c47256fc73ac41288af7f8d52e913acf437082"
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
