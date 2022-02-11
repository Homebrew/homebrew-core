class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.14.5.tar.gz"
  sha256 "332520a6eb2b64199a4ceda43eb19b7a8831f9bb4d15c3a4c043b8f53d9e91f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0bff13841a9f1309aa4ecfe97be1f43b1b823f34d76d15cc04a45538f1a9cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83a7ce29d1757d2ce358b1cf0d5ab73ab40f2381b8c15a29d7f2bac0699c87cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6356333905fd5b68d2d81e9cc0d534bc591ab023645884d3691e6c984b6acf56"
    sha256 cellar: :any_skip_relocation, big_sur:        "f98c08c24f115d05da5c4b48fcf5b0cd66558f2bad43948f615cd278b106c587"
    sha256 cellar: :any_skip_relocation, catalina:       "1b32b0234213d9be622b3beb7c8eb4116e7b6c0d6109a143bdc8e8b32892a7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a71d5f98fb1ed1758c064c3cc74622905d1b95e29a06c46e2d2bbf95ee4b6f6b"
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
