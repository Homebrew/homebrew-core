class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.13.1.tar.gz"
  sha256 "3276bb3a030c7c96bfc56535dd7bf28c41ff8064c467b4e4cfba1c694879b97b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7114b1fc40d833d3367e992870023b23008db954cff5b1ecbf5513cb16f1e5a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "115c9115b6a4cc4e607e9d1364dc2137444e655498e3fe3b2a94a55dd9fb1aec"
    sha256 cellar: :any_skip_relocation, monterey:       "7398111ca517ef9bbeff166800ea5d0824b186ef193c4c10a03262974cce1f69"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d08dd8c5dd937be0e26d5dab629492d988b435476a1be1fe87f8165a95d327a"
    sha256 cellar: :any_skip_relocation, catalina:       "56258d8700ace899a78b0c2ba34b3fda39ea39b3f11fd617dd8d6a96d1ed43a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8952e4caaf2c6b395c69c0c0676b1a3b45226fb397df3c28e6ea1c8e87c67f48"
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
