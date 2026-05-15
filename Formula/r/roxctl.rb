class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.10.2.tar.gz"
  sha256 "ea1a92313c1ed253b643ae2afe895d1461af3aad90ff67b6b891418993d4522f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de36c7ca79880954974b70e5bfd3e4cbdaa282567226071619ca313ca28e466f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec044be15e0acd1bfeec0566fc7a8f51622f4820fa260ca091ab8e047e83310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32de90332e49207b3b6379b1d3136e1e8ee9b9c6e91253a5443ef9e2da080d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "4011afce0b437132838fd03cb78a030d4ba80b8cfba1998a6b475510b9df31a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476f850ea76a8e3648aec1691c72a676271a70863af458c03ba8988a85079dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71aadf792e0d1535bf836ae9ced30fb25e07184793f2d036811d1888a9d21c40"
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
