class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "358a80dbeb499e4e2e82bb2dbb0f814d459669c949f423454175c69ffc0a9784"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d5cf6b5e4d6aa5363c0c3dfff6f010c3db5daeeff044a933d30ee9a5df6b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d5cf6b5e4d6aa5363c0c3dfff6f010c3db5daeeff044a933d30ee9a5df6b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d5cf6b5e4d6aa5363c0c3dfff6f010c3db5daeeff044a933d30ee9a5df6b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd4c1bbe2f10e0f3b1a539e2ab1fb0544213434b32a20e85d7cf596bb04b4c04"
    sha256 cellar: :any_skip_relocation, ventura:       "bd4c1bbe2f10e0f3b1a539e2ab1fb0544213434b32a20e85d7cf596bb04b4c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "263f11d594c4a62ab7cf9ae298b46b39d85858ac22b2615af3e4c0e0c4d50f7f"
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
