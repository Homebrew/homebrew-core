class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.15.0",
      revision: "ac95630ca2e3d61a2385f247a406faa66afbc5fc"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c90dd1e624f1311eb863eeddff55f1dfaf60a3b842ade682eea88236c20abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a74f6466df05eef2dfd6002066c6a694e89d2c9fa1b2a896440dadaf2007eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72257de02d4c7d9519d79f5a284dfb9e6fc0c0a0a017b610d388c6505735b454"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3334764f352be2db197300eb3c413f70c87faf32a4061414277a85ef021ce9"
    sha256 cellar: :any_skip_relocation, ventura:       "c2d348f1d483c174df6331b482e7bd92409d28883888d0bed57be93244a07716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f37779c2b6c6995a2173c1cf255207ee50c52b6df481642e970a074403d173a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a7cc1f8b5f83d8f08f5d8b88fd4a611b9406d4fde955c06cb265be72c6f5c3"
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
