class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.7",
      revision: "c2c71b8974ff004a0e3a2627fb0ebada7c0cd808"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "325082c046beef23063024dafe878ce5f98f349bf815cae86b197d15330b7e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745d031c47fca38b51dc34cc7256eb351dc87ec4fde1f2af7515bf5bcbb9548a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a848c47b1bf6ec96d8f322dc199a9ffd3f13ab26174eb72f840c5741e25bab17"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bbdb968ce057cab483412dd12444c6418b3dbf1ae94d66b902346f7cfdf5b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ff6d7212d4c0c63f020066f9083dba87db02a560d813659bfc12aafc123f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b00e8fa4e5531cf6c6812f30b2966c3a43f55fa76035423e026bc3c61093f4"
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
