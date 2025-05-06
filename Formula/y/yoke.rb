class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.12.4",
      revision: "538b65d2880e96d3aec7415c2a6557300b44cb9a"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a5e58196d80a2a4650b37b7b936975b8b291440edda6127e1862cd7c9da927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da027b507b7d3d43549da459aabc1328f7810025514d5c5478ac94e037b13956"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cea07ad47721c484f77b1eade886a77c1e7d248e42b230ecee2427a3b7a5707"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91700f9bb7367ea34170638aae577f0e0cbfd06ade9129626537d15234d4617"
    sha256 cellar: :any_skip_relocation, ventura:       "5c5e4ca7aee3262cbe385a33733332471f6d2d84c4ee7b5e111f2b69925d49ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef2157ad06fd47d0e4f3550efa504f93bfb5ef6a2b86bc6dbbe77e6921bd485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0952584e9b3ff463497aa2e48905ded73cba564145bd801e1405d4e6d54e5ad1"
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
