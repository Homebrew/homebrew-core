class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.9.2.tar.gz"
  sha256 "cf0dd5764ae49d78ddf5b6c93b140b592edaedb28ba8c41d8ec1c7cdbee20204"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eebc92d659d73543139b7e97ecfd2e16e95f862abf85da27788c678ec7cb507d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464d7df3d63302624b8637a68f335ddc3e1d88504d47753731f349162f4737a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea18d117eb31b55331b589e77c2bfba8afc6a173a9f89f96a520b2fd774b02d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "75d390cf7f6a7bf98e8423f28192c7065f2232701f66e83351df80b65a90c6fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17613b8578b6420767e46df15603f00cce57adce15f31bac66f56350d306e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9920a8793e0864111db1db0b8a3b5c579511c3efb40e78878ed9b98cf27291e"
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
