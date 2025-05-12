class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.12.6",
      revision: "494c01f52f1622d5f023085b64585fcf6cf61bbf"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13cdbe69c990a2ea0ee2720b9f8da7be2e6dd9ee283d31213e21e486fa64dd41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccddf3eb119f8c108496c655f351f5f3dd594bff7095b80338367528f0a7340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eccb101d4515957ede2060416582489a68280c307bec7a7b94f33e1c04f7b510"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9bda3438f119f5da84c9b6df9bbb02523024c8c0d71102c3a01e732e767a59"
    sha256 cellar: :any_skip_relocation, ventura:       "ad326c0ee2d251634043443d1ebf3e51d90971384206002957a4ebae7dcf0f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "188ed5506dc85459a8d22eaea18982ba147f2419dc559151fe4ab47b2bfd5a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b73893d6fc650ce7b5349ebaa7a48b1648109cc0438e39382882bb7fb0b302"
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
