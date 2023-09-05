class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "41ddfad62861eaa8414cda2807bad7a51ebb158c841bd3bfcc1db2fcd3774c17"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77a10a2c0b2c92345f5b8b529732a99c27441eb6534876821196d7bd580fa5d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a10a2c0b2c92345f5b8b529732a99c27441eb6534876821196d7bd580fa5d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77a10a2c0b2c92345f5b8b529732a99c27441eb6534876821196d7bd580fa5d4"
    sha256 cellar: :any_skip_relocation, ventura:        "f319e2022ffeacef44573a6e12af55cba80d974ea3d26226ec1cfa53e8f47d36"
    sha256 cellar: :any_skip_relocation, monterey:       "f319e2022ffeacef44573a6e12af55cba80d974ea3d26226ec1cfa53e8f47d36"
    sha256 cellar: :any_skip_relocation, big_sur:        "f319e2022ffeacef44573a6e12af55cba80d974ea3d26226ec1cfa53e8f47d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd2186b35563f054ade9d57f33355b69fa2a6a5e19e13f767a82bec086f3ece"
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
