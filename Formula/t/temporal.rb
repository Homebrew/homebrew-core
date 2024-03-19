class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "9cc4e80254e95a3b456e7d605b518c1a3e4d62b92a08a05efd6cf897ce4b2f3e"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "601f616c8afe61f86e1bc778e2cef1458120969681f3e5991e1724ce82688309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc2076984038c0f192f58d942610c09e415cfa23ae2575b02e9f15e1b0b3915"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f806c0ddb07813139be877154622e5a5bb3a21565e3c0f0607560a6ea9f3a55b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad41c934bc48f6beb0f02f33ceb3a56266bd805833fc3b456c8171c772d1464"
    sha256 cellar: :any_skip_relocation, ventura:        "61e5f4027f1f26e0b4ff7a456f14ddbe2b2e1b4697bca7a43b996ae0708866e6"
    sha256 cellar: :any_skip_relocation, monterey:       "021e6b2b199d3578517c6ce2eff38314f055afc70e0a3780bf91e816d16f6e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06b7103a616c7561c6c14162238d7dcb67392d0bc69b4c9f8e6659f837ffffe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable(bin/"temporal", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
