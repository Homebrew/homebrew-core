class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.10.1.tar.gz"
  sha256 "6eb656cbed0ff577bfc42afeb4987775ca16c300e9cdfb1e24645fb779f234b6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c420fe1fd2d089e2136e0c5a87676f1c375d26d26749692bac636e153f88a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72ce9d51f6fd8888545e0822b296f83e7d5fd54722c6846d1bc13ae0708267ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c66b4cebafd13d8f7bfcff9cb289119d30f890001e708a9f61c5a01197c845c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e728a5d6942e21893bd0824ab8c1cbc56a5a51f7ee035315afd84c660c3a4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67efc1327ece2cec0fbc0a0c4d1c667a0ab5b63705069d6ab8550ad431f21b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43f785d2e1c9e4db7945825a768d308fa74b947cbe0733895cb87237d235fed8"
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
