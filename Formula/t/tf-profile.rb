class TfProfile < Formula
  desc "CLI tool to profile Terraform runs"
  homepage "https://github.com/datarootsio/tf-profile"
  url "https://github.com/datarootsio/tf-profile/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "cfc5b9c68188f3cac1318b24d0b53ba4cae8af325ae5332865e1f0c92905b20b"
  license "MIT"
  head "https://github.com/datarootsio/tf-profile.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f2be0e109cfe0075937bd1654d7a35776f509cdbbc76099cb18ff546ffed9c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f2be0e109cfe0075937bd1654d7a35776f509cdbbc76099cb18ff546ffed9c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f2be0e109cfe0075937bd1654d7a35776f509cdbbc76099cb18ff546ffed9c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5f59260a96d66609a1ecbfc9e7b10c5b607c9ae64a52b3ea9737244445eabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb717e3db18cfe1755b6f74c713a4dcc9a1884aaab3dc5183f3bc9b14af154f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b114c3deb9e37d74136eb0d45ffb77650b029fd20a738315deb1c0cc3605714c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "netgo")
    pkgshare.install "test"

    generate_completions_from_executable(bin/"tf-profile", shell_parameter_format: :cobra)
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
