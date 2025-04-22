class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.12.1",
      revision: "375758d5b24ea3fc6dad1df3c70c9e56ef8c06d9"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c6e21cdc464da076759b15008e7406bcf1889ef6631efe4c0e7ee4e431b95b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f319dff7c8a30d72cac6ec33d98f0c7a05866dc83976f1c5e2f5ecbe52e1818a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72a27126d7536b9dd24b699dfcebd2f973e23bb47a2d8437890c28f9ceebb069"
    sha256 cellar: :any_skip_relocation, sonoma:        "3271d9dc1c682ddee560f7c14f9753b0dfcf9c7cf0b2c46c6cc60a98edf94334"
    sha256 cellar: :any_skip_relocation, ventura:       "f18a9e084135a2ee69ff9bc709e382de4962364eaa8c58caa9890540da13f334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "777c9241218b65b5c5462b7f9fa0c74a5664124fa07d8a5f6856158609ed365f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c0c72fff1b069ed490dc215b6c63aef0776569ab4058c7f835a755ad0aa9d7"
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
