class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.16.tar.gz"
  sha256 "041c468b21f06fda2dd23c6abc67ddada52ddb77d1450a5cea38e97fdc237245"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e52d0a46ed7ac64636b64172ebeca2a7ab89c46fcbf6965ab5028292ef8ee3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e52d0a46ed7ac64636b64172ebeca2a7ab89c46fcbf6965ab5028292ef8ee3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e52d0a46ed7ac64636b64172ebeca2a7ab89c46fcbf6965ab5028292ef8ee3a"
    sha256 cellar: :any_skip_relocation, ventura:        "0295e61312f6e77737bbfbc611fdc8dd00819ff9c1663f721aea23b6502bbd55"
    sha256 cellar: :any_skip_relocation, monterey:       "0295e61312f6e77737bbfbc611fdc8dd00819ff9c1663f721aea23b6502bbd55"
    sha256 cellar: :any_skip_relocation, big_sur:        "0295e61312f6e77737bbfbc611fdc8dd00819ff9c1663f721aea23b6502bbd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efbcf369aeb5adab8a3324566cee39ebcca475b484dae59a436e9fcb6b57d97e"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
