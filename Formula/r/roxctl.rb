class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.6.tar.gz"
  sha256 "ed6a42650fb8c3c87ff50ece55ff1138153b9106e84b61800accc75fbd884e2f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "699fb0b5f5666c91578ffd942347892daa11b067db11e822b0c4a961e5323872"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b3d1f95657b111b029da9bc4dcc35d6d40c55a12cb1707521eca5a1db1a7afa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c95c1ea4ff5a8db54fcbfadca701d5290006d9b1d6f6e0ddcd795f493a8806e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5fa201749d675c66e9eade21ea5fdee16d58f3a0aee0cbf6e014dd700db3c433"
    sha256 cellar: :any,                 x86_64_linux:      "9e87678a9224daf6f25c0d66a8e661fc1c8f4e9e62412c3bacaaef69e3610818"
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
