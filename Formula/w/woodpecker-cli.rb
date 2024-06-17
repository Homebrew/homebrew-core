class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "5d0ba91d86a0d2a1a4f212a64a1b95291c1a5b61ed492174767182555d59a202"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d313f9d9bf06b2c56721adbd192adc6939b9aba0595013f7822257c1aa5838b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca840077e4d40dc8a015e86171a117e92772a26825b35fd1fd484399fdd0d98b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e094071927439f6a2e64e02e4003adad244839f667709030dd8fb080cd674ba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aae92feaa6cdea729333c5aa90d56a45dcab4ca3368375c87eaf9a5ae045e24"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca4345a479e6c05c0e042948297b7b0053e445b35d12afa67b3344dfe30cab0"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c3c992d9b027816e566b4b61b281bf0986f33243f7ed996b3d6c3bfe24ce15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb76a972b08f0d1abfe27dd519a30888b54e88b6563e835eb72421f3255c40f1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
