class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.13.0.tar.gz"
  sha256 "bc37a6ec8d0e69121b88ee00db59030584130b1f7a12e025fc470e30297f9f08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eca11d4f54073f3f0ae364c34536f21f4f35cd7f3291d212ba13fbfe109db226"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf0403eaf30235ef8e05cb8176ebe409d065241df9646e6990666d955d3ccfb2"
    sha256 cellar: :any_skip_relocation, catalina:      "26d9725f94c88a64f66880b89a3b82b6532617ec94a2d9bf4eff10b030bde97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bed6d82ab4fb516cf1c4ac8cc715f30b32c29b5e74fe6683d6be77047da15c6"
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
