class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "eafec28a4e1941f9ce416605b6022e34e9e2559dfdd4b27d1c11afdee5612128"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0dc48c9afb265bb086e9ce03e0339d77338a98caf3c1509e64de2ab6438e267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0dc48c9afb265bb086e9ce03e0339d77338a98caf3c1509e64de2ab6438e267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0dc48c9afb265bb086e9ce03e0339d77338a98caf3c1509e64de2ab6438e267"
    sha256 cellar: :any_skip_relocation, ventura:        "895b05c8239fc5fa9c9e81f699ed3856eaca05f20e89a3775e21b21d4e83dbf5"
    sha256 cellar: :any_skip_relocation, monterey:       "895b05c8239fc5fa9c9e81f699ed3856eaca05f20e89a3775e21b21d4e83dbf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "895b05c8239fc5fa9c9e81f699ed3856eaca05f20e89a3775e21b21d4e83dbf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f30315344fcdc6fbaf57769fb5d0d7380c393e363e83ae2c3c9b1d2f2255ca7"
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
