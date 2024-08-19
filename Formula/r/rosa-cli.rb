class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "f55f52df54ad82e1edd8584165774752a6cc0e12d6683e377b0e7f417e0922ea"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6170aff543c1654812e6d0e6860f9b69d3103c67a3e5c4f642f97ff8a4a01a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb2af3f2c631938e7bcb9334e6ed9e603aa4040f20d7669fdf2d6e36afc381f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f863610d2c0865e3090fcbc9fa0167a4375fe029f4bbc0a0c7e590a1c993175"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f45617603940bc17b5fdbd2ce3e6035e5cbc317d8eee726038615cd86379026"
    sha256 cellar: :any_skip_relocation, ventura:        "cb28e078ac610ef35640d49ad0219c8a42cc0268c2eb2492937762fc6ba99b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "c37db8952c636df8bf829cb5543e057473c1d595cc923ba3363b86be31cf549a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68186d81ce259e7f66e506913a482a82f1dbdd3c65109b4005e5b260dd3ae764"
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
