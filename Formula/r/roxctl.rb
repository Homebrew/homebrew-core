class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.2.tar.gz"
  sha256 "123d9c5c00870506850a7ad0a308d7a34701ace89cd6208fbbbe4f9eb3ebab0e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ba35c389f4ad983acc2f42aa46a6473ea6f8e9ac091497bcbd41a19c56ac7d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34bc7fc0da97d1db0c87ac0443ea6a74f960c160acd469189c02a1cc6ee9b51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e5d376ec01ab3a1c745ce0c64d0a7c93a7d203978ade1d1b38c9e6981ab804"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb48f4493ed859c0ea0390233e84c4616fc80f95524b7314516c79fa3025b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "069771f0cbf024fb11e807addeae6c43298b254b65ce75d3f95dd750266e9b50"
    sha256 cellar: :any,                 x86_64_linux:  "b6cdc91456ea36a3781ba4cdd3a35669e5c98fff516b893239df941a7f1cbdb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./roxctl"

    generate_completions_from_executable(bin/"roxctl", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end
