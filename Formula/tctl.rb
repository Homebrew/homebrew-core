class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.12.2.tar.gz"
  sha256 "b394ac90d6207614dba57e34ec95922b63a13cdef60f120b103e4075c5d7e0f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "030b3ebf05fa1758ba8f02d430eecd3a2769001ed672b5c6deaef1116dd2996f"
    sha256 cellar: :any_skip_relocation, big_sur:       "14101c2dc8c76f3fff7676783a347077aed55530d4ae349e6ba16315cf269780"
    sha256 cellar: :any_skip_relocation, catalina:      "886f8b00bc73eaba76a9b2107c8f61b4e960c2c58903dd378440a0a0372cfd0b"
    sha256 cellar: :any_skip_relocation, mojave:        "7f11ed7e38f57a53a2be8d03699938a5cea98227acaacfb330686fa13afe3c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc61616aca3a4bdd68d9e9be00315d17ac66c37e355ff057b2dd4b6b8bc418c1"
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
