class TfProfile < Formula
  desc "CLI tool to profile Terraform runs"
  homepage "https://github.com/datarootsio/tf-profile"
  url "https://github.com/datarootsio/tf-profile/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "cfc5b9c68188f3cac1318b24d0b53ba4cae8af325ae5332865e1f0c92905b20b"
  license "MIT"
  head "https://github.com/datarootsio/tf-profile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "634e5dd145e202275e5d16c3f2653b6e0827e3f96d1f7abbcb40b3aea6380e53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d27c04d0f690020ab293d51b7c1bcba6cec6570b0c5e9505c55710a001746a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3d27c04d0f690020ab293d51b7c1bcba6cec6570b0c5e9505c55710a001746a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3d27c04d0f690020ab293d51b7c1bcba6cec6570b0c5e9505c55710a001746a"
    sha256 cellar: :any_skip_relocation, sonoma:        "55fc5b3eff827ab558666e9c4b398da3b813185347583fc9b7f86fc9a8fc8f63"
    sha256 cellar: :any_skip_relocation, ventura:       "55fc5b3eff827ab558666e9c4b398da3b813185347583fc9b7f86fc9a8fc8f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc725da2027e30719d536c6d3eb6c774512abc7264e35dafa00e7a79e34c274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa07426feb28fb5add75bf78c5c11884f62ba74783161b861d70783149eccab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "netgo")
    pkgshare.install "test"

    generate_completions_from_executable(bin/"tf-profile", "completion")
  end

  test do
    test_file = pkgshare/"test/argo.log"
    output = shell_output("#{bin}/tf-profile stats #{test_file}")
    assert_match "Number of resources in configuration   100", output
    assert_match "Resources not in desired state         2 out of 76 (2.6%)", output

    output = shell_output("#{bin}/tf-profile table #{test_file}")
    assert_match "tot_time  modify_started  modify_ended", output

    assert_match version.to_s, shell_output("#{bin}/tf-profile version")
  end
end
