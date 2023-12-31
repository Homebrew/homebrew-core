class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.32.tar.gz"
  sha256 "29bc1069bc960d2dedbdf37a1332138130e102e6558211f256b0193d5337ccf7"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e31dab80df390d41ca0999fa2b54b9dce480d9ac53cea5d7257ed05146d0cff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad1ea0a93af637f36de2366542027e3eaeda33a7ad15fb38773a1cdaa06b740a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc93d5d7da29f48eb726075a0f9baf756f40df7c8144d2e14572b38f13601ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdf11f6fca4b00b790a9c51a5796837178c5b041d42d1b0c8624aeed14af90a7"
    sha256 cellar: :any_skip_relocation, ventura:        "7a9223de093d4704205d8d9f5b2069341f10b7a916c5da2ed169874aaf103450"
    sha256 cellar: :any_skip_relocation, monterey:       "5a19a54830af055156d278140af1f26490ca14a3ef76782b5a7d63f8c655b968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ce65d2f46db2d1c8f08be6216a400c8794eea45fc97868eeb1a828bc34849a"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
