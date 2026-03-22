class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "fd6a1bdd91bf5ff2dfdc801678de85e3d73718e0878e43766d56255ec91a4944"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fd4b19b9cfd0e7ba841f346e4f541fe1ad1b9dc73ba3741babe57027fb3f586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd4b19b9cfd0e7ba841f346e4f541fe1ad1b9dc73ba3741babe57027fb3f586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd4b19b9cfd0e7ba841f346e4f541fe1ad1b9dc73ba3741babe57027fb3f586"
    sha256 cellar: :any_skip_relocation, sonoma:        "112c2d9fba139e54bd05cce40c4e1c62dd5d01285f46fce0b76607f108b86e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36e900e3891748e4a2063fe51398c9b9824aa3ed4e6cc030a1345955f446a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da612e7334c621f34092406f7ad1328696e911a9a82fb190593c9918a976958"
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
