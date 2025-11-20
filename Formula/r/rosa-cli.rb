class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.57.tar.gz"
  sha256 "f02757e4936958e35f84d785bdd99aadd02b14599527f722a5742d4bac59add4"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76fa2933976bf13c81823b87f8c5dc4d47f3bb78b1ded5cedca43580ec2715bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "372ef5c6b6abd6a0e8ba6e87f5bc771e5b256ca9fb3ee662737d5e370a13ea7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d164b3a7dac7c63fdb4d26b68296583a3e9a25aa75fbe4cf3dc93ab5b75acaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bba0a0bdb02328ea274b0f6a80ed1e5242027f720091c39c83c3ccc38113e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c7ca49b46c5aa1f2320cadce69feda61ba97bb101245efccf174d492bece9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8cf08b8f74c2b2afd7ec9aa2dbe0f444caf3f5eb51acc2e5c89abd0146b68f8"
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
