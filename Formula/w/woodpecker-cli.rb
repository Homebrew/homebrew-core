class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "77e6cf71266b0b11a045a71da17bef27a65631a32bf717ef4f85c539101418d9"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dc4d07dca613479ebeb0050593405c558aca54014b1250782aa3d95b2eb186f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dc4d07dca613479ebeb0050593405c558aca54014b1250782aa3d95b2eb186f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dc4d07dca613479ebeb0050593405c558aca54014b1250782aa3d95b2eb186f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a640746e58da818f060a467d4ca9f284c752208813a764b251fd7f25192fc9"
    sha256 cellar: :any_skip_relocation, ventura:       "b2a640746e58da818f060a467d4ca9f284c752208813a764b251fd7f25192fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f8b898d1642b7387c6ef5e5eab9e57eb9a863076e75337db570109172eb7c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
