class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d136f0f338176ba61e804f110d2ee26cecb389cf1232e73dd0209941c09b3d36"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8035a8ba2f1ae24ac60b864e8c24d6d8a0f012cd1b45c0ee8554d21586bf7922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8035a8ba2f1ae24ac60b864e8c24d6d8a0f012cd1b45c0ee8554d21586bf7922"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8035a8ba2f1ae24ac60b864e8c24d6d8a0f012cd1b45c0ee8554d21586bf7922"
    sha256 cellar: :any_skip_relocation, ventura:        "ba98efc8a3ad098ff3e6e81b325d0455fedeec0d529b3385e801ca02b0dcc678"
    sha256 cellar: :any_skip_relocation, monterey:       "ba98efc8a3ad098ff3e6e81b325d0455fedeec0d529b3385e801ca02b0dcc678"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba98efc8a3ad098ff3e6e81b325d0455fedeec0d529b3385e801ca02b0dcc678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f890376e0436b95af058cbf44e8fd0c72056d834a5ce4ca1e526c832c6b0506"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
