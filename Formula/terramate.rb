class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "89f59e39db26ff3651b0a6b299d7f918b62db8892dcb25012f1e4f9f76127e14"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1b51e08d2d44ae5b162fa9426888d2ccfafe1236c4d1dff051ab88774531c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6371505ddaccf178dd7407ad390ec99bb0db853ab2a92545d9b27b2a497109d4"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c09bcfe54a96dd0a1e19f7bf392368674752df1e250921cfe656d1b63ba44c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a11f48c6e53819ed8ad9e91f9c333dbf76ea0fd871c5edf2d31639f2fc62f43"
    sha256 cellar: :any_skip_relocation, catalina:       "7b340dc289f2d150b944b42a7452ef00d218d315ab62ca1444bf836f3f1bc231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d342977a55684ffed31e0b2ee02c5224d9e121995489c67c9b66c43887ebf88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
