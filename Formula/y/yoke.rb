class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.9.3",
      revision: "3c0b7fa00c5b5355370c569e6b73acf35c78229d"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb4d14303d0e106c110f56850ff59b051964562891c10b4592ef613110f4493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eb4d14303d0e106c110f56850ff59b051964562891c10b4592ef613110f4493"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eb4d14303d0e106c110f56850ff59b051964562891c10b4592ef613110f4493"
    sha256 cellar: :any_skip_relocation, sonoma:        "157ab955f0bd2fef270fc859a60b6abbfed8110d9d21a9eadfef12889c83f926"
    sha256 cellar: :any_skip_relocation, ventura:       "157ab955f0bd2fef270fc859a60b6abbfed8110d9d21a9eadfef12889c83f926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63f02fbd4897e5195b990f73b7d4fb943591bd5c3dbbd970922d41d7f63ec81b"
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
