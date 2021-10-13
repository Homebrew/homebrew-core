class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.12.3.tar.gz"
  sha256 "44d8a8a40085db50aa655ceebcf2b7df1ac8011d1ac4e2d49dc682e503820f2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f7c7bc02f74eb2a1a42c7fe9b152b512090acf29cd999da5c4d314712bb5d00"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc9baee6ccabcf595d07a207afc60eda1cb56d6eeed4efc46b4880143a504f7e"
    sha256 cellar: :any_skip_relocation, catalina:      "2e5e643ffd01f0fceb0259a1e1dc8fa3d48e44bdbd9ecb1591efd7ddc181d3e7"
    sha256 cellar: :any_skip_relocation, mojave:        "ebf347dc25bfb6adf5700d96078d4ef273cb36a522bb439ff45d8dc01e3193b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2be65b489682c2ab5d5677c9732e8af4f17038c2854a21cf77a1b19d034604c"
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
