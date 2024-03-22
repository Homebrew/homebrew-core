class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.36.tar.gz"
  sha256 "ec3d784f1235e90265a5a348398217d057db97371e9f7291497f64d54e67fd47"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d26246dbe39818120ce4360a772d6e785025414cae64597feec1bdc88b9f2638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67854b99ef7042f9c81bcfc51a52afd02985322c2ac4f4d8248a0e5d8432a79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2c1f36b0e7c927ac31f211d9358fd947c5a6a0bc43863acb34dd6e50da969e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ed6b7f24023973a54011e55ba5269eed5a09dc1e8a715f851a627c374900235"
    sha256 cellar: :any_skip_relocation, ventura:        "857ed571a05192e64dd8e748e0ff6a7194cc4eb90466827b77290189af108b93"
    sha256 cellar: :any_skip_relocation, monterey:       "a476af7fc2fe4a1320e61b225ad2848e98edb1f5fd7fce303939fea551a406eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401caf743d168618eb9444d0f3f75affe7e9ae67e843b71c8dc48e0c63d8de95"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
