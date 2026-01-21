class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.7",
      revision: "cfeb4fc7837c29190701d4eb6ac2f614ffb6f215"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e734ded9e83906c76db4ec4acec812bf9172926adb17e5edc1ab516af890d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1c51496c8a36b260f68a6cd34c13c1503da897dda31a58fc11fe041ca06048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68b9e9e37477c8e6845fff9ac9bd0e1283a12275d32a06f070fc38ca6adc6d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7fff8d3a7da6576661f3fa8ab9db9d91c2cc3a9f88033acdd8383420da1b3af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16c3af439335ab7af76f3a82f590d9fc7308bc330fb9292598802394f0dc564f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f9a1748a18757b3d788e1bb8f7131e4e63e0d61255bc9db0e1d4745c5ac919"
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
