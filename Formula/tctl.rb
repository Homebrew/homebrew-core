class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.16.2.tar.gz"
  sha256 "30c7bed35360601bfe383936c67b11e003c9a409b177c3eb2e78d5884b720182"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61008702b5c27f8f463ec05837dac57b7f0b8287732d6a01a3e767155870c82d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a09cd6068e1b77e03287750b1e304b2655cc7d5c540e586d0c31fc6e78a07d4"
    sha256 cellar: :any_skip_relocation, monterey:       "e40b7b4e237a3aeab34716a0026e2130ed7be7134fe5c82246cda2cac3d979e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5180190623183f8dbacfc2912b0495856399c258c63bafec7f1774b9192e910"
    sha256 cellar: :any_skip_relocation, catalina:       "91e6e1fc848b1fb28cdc06404633ae18e0589ee68bc7cdc15ef0180d4dea88d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bca761a43819b52c4a90768ae37f7180533c8acf7d1e36b19ce012e6bd16ab"
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
