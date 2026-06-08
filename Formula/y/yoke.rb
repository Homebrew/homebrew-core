class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.15",
      revision: "844fe8b8322bc4e38d95cb29afbcc80ae429d36a"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5390695d3ab78777f94d9f84962be78426671fef3dc4bdef1ae11959802af718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02deedeb0f41b837ffbfa9d434b12dd1801a4b61c80c78f0629f3af39a1563ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f02f8811f5494460539d2a0cab45db40e263bfc75cc3b4de8d835bbb9d219d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b89272a741e2a3fc378d119497f9c2095d40a5afaf2425a218a200a5c2cb3714"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1b9826db2ebdff0e743782c3ddc1cf8a348aeec771c16f988f861df3f899c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f72f6b850e7a5e176ae2a25f04843d9e5556d986ca87aa67c9ad1fe2da1d23"
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
