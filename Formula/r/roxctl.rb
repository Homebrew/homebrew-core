class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.1.tar.gz"
  sha256 "a15d25fb94570be08c6515283901cae4915aae26408e6af23f76fa794e98f684"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7664cd40b83c9f0b548a94b225175bce8df99e2902574859e7f1ce759e504cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948210b01f3859d2ba50789d8ea84ff539fd2cca14063cf3a000bff03e02fd6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb301c588580539bb6a82a1fd783535e0384c77d4f183feb358fcc4cc06cc71"
    sha256 cellar: :any_skip_relocation, sonoma:        "43cc140158e7d61ec2e1dbc2425cd90216bb1eb1dac77e72d3ae6f0de68cc85f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0ff5f0f27784fd77b740b1c27d1169fc0d8591381759faeac93f552e02956f"
    sha256 cellar: :any,                 x86_64_linux:  "14918412a86ee6cfe6148a09366590700166f907bc2ddcdda1f3e8ec9873b7bc"
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
