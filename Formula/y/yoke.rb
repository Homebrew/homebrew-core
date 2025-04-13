class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.11.6",
      revision: "26cd1fa2a499306361186a0ea1165f3111aa8d5c"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a08788f5b9dd522e807d4adb437a8fbe8cfcb1493508aa4f2ae3653418944d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69dee1626c4abcc18b8e98efccfd8b09ea005d94db17479ef769eaefe908a290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b96d19b78854df4e386694cd2d91818318b1eb825d812b5bd2d1cdd4bfd4ab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1356d18e412d773f10a8c3b01a3a147ad9b3a9332ee90563e1793901b4003ef7"
    sha256 cellar: :any_skip_relocation, ventura:       "e8c2abba21cfdd7003de46ca358b699d73918a313cbb8ed3f10279160a3ef373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b3d4b367cee6248c44b0146793f181d07e2be0ffda04b8e45fc75a5ab8b658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6310cac6dd7ab1d0a1e1c4c186fc79a2005f04b664506087640b0d0c6e802394"
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
