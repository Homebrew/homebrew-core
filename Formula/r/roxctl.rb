class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.9.1.tar.gz"
  sha256 "7e18660e02f778771a4128e676a16dacbca2afde365e114da6757367cb6edd8c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a092f2cecb244f1e4d4ac57a56e1cff6593aef1404bae0e4d7d947958e855986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de3dee793d1221f6e8b5a615a13f5904237214d9866907c31147100ce762497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5ff557ee3e52a592dca11577f74969bb24f8f744e43e936523fbc216e6c3c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0057223a349b25807d64182a94e12c3e3a13d2d2c352afe92738012543c39c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34db6bcd1c1017d4dc557c6f4c86b1d64c8eb077a84ddad5370f7b1ede4cf479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fe326cfac8d9686022e78d6f38d3c34e674572bcbea11765fb950b1830877b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end
