class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/5.0.0.tar.gz"
  sha256 "e0ec28133210c71b51aa3c8703b50c28b0bd427745d66851eff6f7c32ca61942"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cd54eebd61efcd3be5904bd34d7ac76187ad3dba2573236098be34055a39e03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7459b80a91bbdb3eb69d1929ab6027d448df28811a8948278e1f885abc814b66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0e397f7a3531000c8890a7176e299a22e5e86410872ee00d6d6332acdc44bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6528f5451c20a56eac9e5d78341010b20b858c88d1fa0e33e3836ce3535b2cd1"
    sha256 cellar: :any,                 x86_64_linux:      "6604d31a57f87acd19b908c87c687d014cb5b85337d365c6119fc166bfed0d60"
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
