class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.49.tar.gz"
  sha256 "aeeffad860775314da8f65f8a02c256c4d063b6ba27ad902d924af6ae97d29a1"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69374f8a29b1bd28cd9e51709b1b9813c3d2ecad38de1cf2ccdf682b902d5ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24631cffb77b3bbe77a29b7cb2b1e4bd48116c7f6dbf29d2942531c3868ec2ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae20e5c71d8bfa96e6b5b8d907b4aaa55648bd0fc8755fa6d028b033f558ac7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "69c3ffb90e27a91dc2139397a1c906de3937180693a546b75c229fa1e5d1ed61"
    sha256 cellar: :any_skip_relocation, ventura:       "01448cd7b6691e8e1266888de022856c16c7f24e9eae391eea06d000e5e921c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae433cde47f95078db5e97294f95ced4ed9a6e74d2346fd7d79550ac5c7b3036"
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
