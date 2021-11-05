class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.13.1.tar.gz"
  sha256 "3276bb3a030c7c96bfc56535dd7bf28c41ff8064c467b4e4cfba1c694879b97b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2361eec4b72cd5c7918e2b8a280ec93a608e2778095f03a2831e109f49c4fd4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eca11d4f54073f3f0ae364c34536f21f4f35cd7f3291d212ba13fbfe109db226"
    sha256 cellar: :any_skip_relocation, monterey:       "25b19bf81b4d1ff167322860011edcef76e77b717e5862e85de41f313611c769"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf0403eaf30235ef8e05cb8176ebe409d065241df9646e6990666d955d3ccfb2"
    sha256 cellar: :any_skip_relocation, catalina:       "26d9725f94c88a64f66880b89a3b82b6532617ec94a2d9bf4eff10b030bde97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bed6d82ab4fb516cf1c4ac8cc715f30b32c29b5e74fe6683d6be77047da15c6"
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
