class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.13",
      revision: "51fd4124c6b4ee3ce953d21ebd9321d93f341a93"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8bfda1c2f459068ec723b99afe915e336ddccea688b5d9338fae59238786c14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6daac1fc6884cf8f95cbb16ab77d54ae8e8d5266c9daa59e209bae21cba16b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4a1b7ddf195fc6a038b457bf01e06b615bac74ed729f12885cbbc80fa8f68c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7b427dabb0b31248fe89a23093d5cc65190c4a5d93d68b37dad935b3a9cbe8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a48f50ef1d7454ae9a7537832f27d8e2801ebea089c1b7a51a568bebe53d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1574f1b7cc9c600876ed39a1ee90cd10c88206116e7f3b1e8b6f46dc0c369477"
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
