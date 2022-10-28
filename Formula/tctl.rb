class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.17.0.tar.gz"
  sha256 "3408622a2112cae4941782afbd369ff2122728f7daeed6f7261a83b7fcf0f2df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d02128776cd3000ca2d409a4591e167bc144452962f97530ea09529c03068a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1aa47b76a7823ca2c78531415f6c3a606d4e6d74b47401872583a54611c236e9"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c562c348f400110f4f2918562c3222717ba7a9352b610629be04ddcac16b4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae689d4e7a7c66beff701316683e51d3710d8572f6bf39062e22c555889ee921"
    sha256 cellar: :any_skip_relocation, catalina:       "9046104ab1fac0dcd7790494c0e2b825011d005e417ae5a1943a84bb4463f8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56cef6847c89b3498f9d6d3421ca19d7412105ad69c750c8bb9c8741d60e90e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tctl/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/plugins/tctl-authorization-plugin/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
