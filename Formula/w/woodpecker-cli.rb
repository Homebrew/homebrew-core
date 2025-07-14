class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "e68a88df7cfe3f0f0eafdc5678df705f5744e51c6d32eda6d53e6971fa3fbff6"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdf40cc7185c2ca7b648bf63bb65775839459a94af7a0b81d7b1bfe685ff1cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf40cc7185c2ca7b648bf63bb65775839459a94af7a0b81d7b1bfe685ff1cd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdf40cc7185c2ca7b648bf63bb65775839459a94af7a0b81d7b1bfe685ff1cd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e6682faefd21f6da7799ca6ae1af9fa7dda205b73c923cced1783ccfb47f185"
    sha256 cellar: :any_skip_relocation, ventura:       "2e6682faefd21f6da7799ca6ae1af9fa7dda205b73c923cced1783ccfb47f185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce97eb52c5dde61c209b35559eebcf14e85b5719b570f82911ffc353546abd76"
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
