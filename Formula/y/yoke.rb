class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.8",
      revision: "e38e6cbedac8756e936212fa7b922c9d20e1edd8"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16fb02458c0eb0e5496ee8386816675fbc051339a3d54d71518a0cfd37ec35f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879d99444a251c4d7722f7c1bb50aa488d37992d208348f6511349c41330489f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88a12034f8e39f11b473e52c2847a8ba54f309130f4f930551b09738cb3a67d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a9139e150136120430d34d6815169c7a9af309a6f680e5b579f4976010880d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fd6b51683406e5a4c4267a9f8bef08231efc0210cfc072eb9414cea45cabda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "949110407cdbd515a13b791d51f7d48a8430040b2cc7133c1843333f091f1c79"
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
