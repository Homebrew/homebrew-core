class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.64.tar.gz"
  sha256 "f9e4df458e9df52158a19894f0818b457c18d61ba18b66e960762e679574a91a"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0320732b42e9fb1fa458c8eb47eac71ef6d25f337518e11f9225d67cf47997a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8e380a7fefffd2a72b739915a2bc161ad56e6fd918730a746372fbd0459c583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caeca34d34a0392cd927bd3e27f9bc2a04984f08ed35f0092c21019fa0f05a69"
    sha256 cellar: :any_skip_relocation, sonoma:        "524ad574f94ee1cbd5c2a42d2cab358fc008d8faa0343942573107ce765de7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b448ea9c7c525ea97cb32d83a4918962061a6728584324a0bb5af1f4485a0eb"
    sha256 cellar: :any,                 x86_64_linux:  "d488dbcea38c1c017c29fd7570b2e17b043bccc6063469282ced08976de3ad06"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
