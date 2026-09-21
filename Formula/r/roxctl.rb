class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.4.tar.gz"
  sha256 "ffb8acc5f271b02509429514536eb34e71d2bea22edd833054b89635168807e0"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a65b4d2bd569057cea3803e725ad6c9ef728df0341070b90c110ebd08cbb153"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80dd1f97a99d11b0850492e76869efcf20ba6152c0e11b1fc154c1c5d41cab4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d225823e4841036b3a4b5a6ec8fcb13c1d79a1fba911c40cb1d1f3a3f192a3b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e20aa939f77f9997e2acb9aee8b0d2d1595cc5a3c71c7dba4f5ae5f21505648d"
    sha256 cellar: :any,                 x86_64_linux:      "27b4d6f536cb90086e09d64f1fb37624bd7f597a6491d9f965bf9991898d6a82"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./roxctl"

    generate_completions_from_executable(bin/"roxctl", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end
