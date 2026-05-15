class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.14",
      revision: "891f504c0aeaa7173c99bb0bbe4a95d1ff6fb33c"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5676ebc5a8d3253f9f7a4b9ab8c19fb42d54d2059816bc944cbe53c5d2e55262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a0a1e59ef5181ee3c084046769a9cd277f2fd28b696dfb59b3c6eb415cefdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f471ff39e7a2e103563dda5bf69ea4c75b91f730320196c9eb44a50f827fff09"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c8dd6ea55183b21f1b390c0bc7d032f235ab08ae0567dbb2092e3d1bc370ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5762d631c5038abe5da2fc945e302b02ef41dbc9855e17669eb4a1f3d8251b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73c53079916c640cd959b4a566e3fcc7eaaf07188f31056f813464ed477d167"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
