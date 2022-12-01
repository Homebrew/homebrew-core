class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/v0.2.0.tar.gz"
  sha256 "b8f83e07f47994482b73e3288083f38635aaeb77de673920041307254363f5be"
  license "MIT"


  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version 2>&1")
    assert_match "temporal version", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
