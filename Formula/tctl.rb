class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.12.0.tar.gz"
  sha256 "04c8612f1553c70899969e9f134b81d6fe54db7e80b580be189b1a901fe92659"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5251425199cf3ddf80a562369d1a33782cb8deab2922391379ac62e1c86328dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "3769f151c7e4cee251638b5e74a91c6d4f3398712ee065ba1132b1980eb792c7"
    sha256 cellar: :any_skip_relocation, catalina:      "dc6f55645bed87939eac9c7d48026f19d2b32660debb3960c705820ba49a609b"
    sha256 cellar: :any_skip_relocation, mojave:        "426aad78446c97d83e2fa57c146bd3d03babbd96baa7f8eb4dda5f6f7485d1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b4b9cd995c3b69cd48c5d9cae63ed14060234f97b1d286b791ac78042bb828"
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
