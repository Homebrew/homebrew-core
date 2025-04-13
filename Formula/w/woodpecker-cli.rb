class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "ada4d4bf3015afd9f42c04370bc39c69f81e4ce8a76ff5aafe194fcff49172dc"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45a6f60fac9376444477223ae35d855e8d8caaf492552720fc9dec1094112b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a6f60fac9376444477223ae35d855e8d8caaf492552720fc9dec1094112b2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45a6f60fac9376444477223ae35d855e8d8caaf492552720fc9dec1094112b2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9888bb1e7eddec0d6869b70e115ca9df04a598699e8e00398c590c9c20fa863"
    sha256 cellar: :any_skip_relocation, ventura:       "f9888bb1e7eddec0d6869b70e115ca9df04a598699e8e00398c590c9c20fa863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e486eeb1f5de8e1664da2041f043eead84815f2f95260126ba4e71466f4cefc8"
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
