class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.54.tar.gz"
  sha256 "6bb473213ebb4088e44fbc294a27e5d46462f03fa91d0b46e0b3ed6a7a65d7c7"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82adefb3337c42aa7ddac732761843fbb8d2fee3b5bedceb4bec0201640a2a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e300153fe5a989382f10e5cce2dadde7513d87bc18e8bc5aa54ea0c661b3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db96e6c794ef83fc5bd9fb397c6f11a7f9e0bd8ca7e64a39efd73d6e717a82ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "768b478fc1d5bcbc317d28a5b7fd7004b7f1241824265c1b0915033a6aba7b8c"
    sha256 cellar: :any_skip_relocation, ventura:       "0a91695b82be6481ee1ce119d274c5931a15d00a33addda81d4c1d0061b23bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ba21e8b6776ea781ba771eb9ec01418f3ea04c6e28b7a4d1df0f9723eb8955"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
