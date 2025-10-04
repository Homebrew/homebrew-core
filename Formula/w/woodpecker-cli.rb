class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "d396d6a5a5c349427b8a37afb96c295cbb3ff80df525b4bda37a56d64fa65feb"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dec179b763f7dd1a3dc62086bd6b1d625e02f0429811e4dd64d60f6f16ba460f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec179b763f7dd1a3dc62086bd6b1d625e02f0429811e4dd64d60f6f16ba460f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec179b763f7dd1a3dc62086bd6b1d625e02f0429811e4dd64d60f6f16ba460f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e71c0f48e2766d60f48123c10aa1403c5aa4d17fb410cd36441b5ff0d5927e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa4b5cce653fa4646334cfface31ad210ac5c3fd8469b1b2f9794e8646981eb"
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
