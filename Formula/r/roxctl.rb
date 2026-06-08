class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.10.3.tar.gz"
  sha256 "372d7e549da4cf323a317c510b56ba954a2c88eaccdb1850e41802143f4674c6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f351dc6d547d6121630bc74e59070ae6520870e0494583471d3c87e66c573bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "201785bca1ce261c3befea210065eaab2ef7094b436c2c768e5316dfc2bfb6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "322e2dcc27c68996f62c0c00ce7bd1cd4308481d95b72e4eeb26d5303d739588"
    sha256 cellar: :any_skip_relocation, sonoma:        "5806ff8cf5b9947ce4e2fc67672af6961f3aa63309a39d51d7f8d27a655eb30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c9cf9a9c7dbf16637c825bcefb741dc38ef423b745a51d6e698daffb70031f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f9b6f6507dc90a73fa3caf9fd1c7f978ed25bda8a42a19d37d2811a788ac6d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end
