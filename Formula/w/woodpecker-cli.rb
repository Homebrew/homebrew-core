class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "d450fc666c14bc106dd3009152aac1cf6ba871b0daf7412cccec860ee098bb4b"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b9089c744f91ebc7ea0e4622bb70887084b5b2b9e6101a22dff12f7661e750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b9089c744f91ebc7ea0e4622bb70887084b5b2b9e6101a22dff12f7661e750"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5b9089c744f91ebc7ea0e4622bb70887084b5b2b9e6101a22dff12f7661e750"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b23ac633fdca58b55cdfd0ba5bcd7f6b334fa26844ff17f40a44ce128292e8a"
    sha256 cellar: :any_skip_relocation, ventura:       "0b23ac633fdca58b55cdfd0ba5bcd7f6b334fa26844ff17f40a44ce128292e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "633b65ec62470da27372fbe6cb47a69c7d5cb90eb9e2c636cf9648e66169f8ad"
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
