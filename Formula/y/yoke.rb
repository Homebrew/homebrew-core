class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.5",
      revision: "5b98cd308ecf40a8c52c70f2d6b30decb92db3e6"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "401f69b6d6f1b9b26516dda0e13a3ab576e66a6d9a67d3154694b34ae8ac9a1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e777c7c1bac08bd9de382eb25d814ff3190d37a5b3d11f0d19bbc742198f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67bf057b11a95f66e3ff6f3cb642d54ffd22129a781203582eabd3ddea8a6a7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f3724aa9965cc15a7a229062ac272216bb6f2b46ec4e25ecc6b068c82dc1fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b209d3f6a18594647e0f495a358f39b29c356aaa2e1fda0f65e46d1f270e23f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cbbf882ae828f74200c21764b6677565a0832d5a706eb2281279f2293a1c4e2"
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
