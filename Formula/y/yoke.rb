class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.10",
      revision: "1337bbe0c421def876bda9b712d62e78770400ce"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "114af40fefc1ccd80d5a1a6807ee1f60a4125649ab4073c7dbd31f6c8c5ebbdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e32ef840d3ecc25a93497d0a97e825f123505b3ed4888dc0b1b478ad59bdae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93e7c8d3580c74db6b50c09734b97e24c2f216b7cb5a1f109149fa64c4aa3a2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f419edcac09611c4312f05163d8259e118e176f90c61541a1c2bd32be2aecdfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb19faaf5131c198da326b10f3a7b924d507088741fd7b98d0abf4c41027fd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e130e00270efc03c5ef4d69285881329ca8c772518c34f8c6e37ca60035d21f"
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
