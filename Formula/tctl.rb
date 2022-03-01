class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.15.1.tar.gz"
  sha256 "20e9dd503c0654adad411756ace1d4fe91ffc4f5348f00716993f7cf131eb67f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e91fbb05a18e4ec35120498aea6f3f7442a48f1d9ec8ddc3eb26fa3c6abc019a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c09808196cabf352fa818111f9ebec91c1c25451c28b533f7daf3334381f7bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "f62f91ffdb6b0333a470f090325dc2a21ba53d14ce80cefeaca11ad8dfff1180"
    sha256 cellar: :any_skip_relocation, big_sur:        "810f69b51147e00d2c389946e44fbc89ec0dde02e81bb12139e025d14f6ec189"
    sha256 cellar: :any_skip_relocation, catalina:       "2a7036c5a883f3dd2d60771b48c833f6a162abc3b3cf0c6aebbc38c6133bd274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2beba0b987dbff7332737c4651cc58db28029c0b669be9a7795b6244e0e1177"
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
