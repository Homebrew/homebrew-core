class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.7.tar.gz"
  sha256 "85398baace5d5a828c173164afb09b596aa93f715c0c5b07c02d8b73944d2608"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ebbe31449bbe0b2df3de1a1f4a30fffb3785c6b0cf415cd2dfbe15ecfd2361f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5281ef01ac116777c1298de3f59213ccb0596e7866c8fd7907d03c2a38ec96a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "119bd7f4d6ef6af917c60cb58eb664a22c6bde917e03916adc107ae71bbc0dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5488b89d3978f85e78bd59be39202d46845b3a663c28026730f2831b1c9d07c1"
    sha256 cellar: :any,                 x86_64_linux:      "fec4f24ce40f8fbda1364af02e87bb87870d1af4d597e55364e2d095497f97de"
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
