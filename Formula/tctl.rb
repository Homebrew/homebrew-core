class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.9.2.tar.gz"
  sha256 "d81151dd1f5c58a319399428269ec90836f68f6a4b836ad79e669e5a9558c265"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a46701e203f54c6c65e8700eaa91519279c8e3433eee0bf1b6b0d1155ba4fec"
    sha256 cellar: :any_skip_relocation, big_sur:       "61b3f7a0e799ed678739c52d58cb439b0e9d2aa517ab2f6e9293c12fd854f016"
    sha256 cellar: :any_skip_relocation, catalina:      "fa218cada607a98c023bc205f2a066f1606dad27a456c7d7057169450c3c8f54"
    sha256 cellar: :any_skip_relocation, mojave:        "7c7ebad5c637818e9dcc23cc888a1726e1eee0436d684a049da45d86d910111c"
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
