class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.5.tar.gz"
  sha256 "da8279e8ac5945ddbfbfec9dbefef8d99ac911dc37fc97cf725316239512c72f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3d4c6a85d7a556543fd9bf5014fe697140a9135770e490b0ada119cbaf3ec57"
    sha256 cellar: :any_skip_relocation, big_sur:       "61c675934e3bce6e86fe3900b5d7c6b8f7bc7cd45b8cec31d537180ec8f7b5ef"
    sha256 cellar: :any_skip_relocation, catalina:      "9c3a60dca46ff5dbe020a9b09daef15f20aa4bc6dc4509d814e7d38cb9087fd3"
    sha256 cellar: :any_skip_relocation, mojave:        "c09a4f2d31bfb81fa432aa03859bf6a7e260bde8607c325fd0ab618b7b6557f9"
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
