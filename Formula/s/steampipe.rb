class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "3649d31482d92a1eac24fcbf3970076bcef97b7b82bf33018ca4c6592cb26d92"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1feec0209162befa06a09a098317e6a075e00e8fe012e624d0dfbe7d4f18db64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b029a03c6a215f726fa662f3cd892c46ff9a2a4a5effd9de0a2d1a80237b47d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb2b10cfdcbc97e1012560a82bca612a4951efa53fc0cb5b9821a0b84ef9203"
    sha256 cellar: :any_skip_relocation, sonoma:         "3030b87ec4b9d092373c87693c1ce405e74e152edd83e5be9c9d934e4c496274"
    sha256 cellar: :any_skip_relocation, ventura:        "dfe26b3ac1a5e0d4e0f5cd9c1e844ac7a986156433eec88e1c569bebe2385ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "4b3c098569e1a2a1bb0eb1789674040e5a65ceb62abc6af1e88f58e5dfc5022d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9c2f98ad9a6a4b3098c0434a3d47c34b0f1289b5892b97ad725e1638b03a98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
