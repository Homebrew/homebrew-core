class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.11",
      revision: "d346dc566f5881ad940a88e0fe4169fe7a3f8680"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e0ce12860d689cd21427bb0723580b1b9eb116e029b4fff3f2f59f22c431cbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d4864daf367d58e66595cc5a52b4558e760a1975a4d7f2d5f540aa3dda5821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a9c1bf58df591232aa0ee1a48be5995b7d97c2a0ad536b8afb3372913e203d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbce3300f52efc29d473bffea119d9346f2042f3a7b025bf5d79433c1ee5f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce4b7f9ad6dcae5036d5a78043d84325ed23fef590c29b19c49df9ab3eb55daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7c7f2a017c5fc4d44cbf9452feab061d33243e737b8e32bbb35c89160f4127"
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
