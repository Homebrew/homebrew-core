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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acfa30c290b5627d81a790b61ee1b6ab74784d123bc47a4f22c5191311789a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d355b20284ad450ab3774b07f282d9d8636edd10d011394a665f3b39e1b82be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb723c7c11cab405173f07f1b8de7e1e31f91e198ad6908c2c4c4cb3b2e64815"
    sha256 cellar: :any_skip_relocation, sonoma:         "99f99361f57c430c298b3f0cc37dc3f1039eb6d7a24400df00d8a02c6f8d249a"
    sha256 cellar: :any_skip_relocation, ventura:        "cd4d6c4d6ea659634f41d424b19585f99d5e1a3f9b2a45381bf6f928fbbad301"
    sha256 cellar: :any_skip_relocation, monterey:       "77df80178eb4690e54b8f9748f68e325bb894b4a7a25655032d783abe6e908dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e54a5ef0f3aade1c4ba0c7f2dc454557e96d38e22f0f28fe8b8e21b9fdb0c3"
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
