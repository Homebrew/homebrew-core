class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.17.4",
      revision: "fb2572474e38abca1cbda6a63cd90b2c2b5c3d06"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb40ad46f0cc29ff7f5ce0d995d4e21f9bad3c44a46bab5b46ca89d4bdd2557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e538dc498244c5f48d9a58bfe13740d4ed9f9cc4dbcd319c517a38c2b9ef681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a84ffe36d78ab67694ecf0e7412d93bc4806707b24e3e58736eb5be1829498"
    sha256 cellar: :any_skip_relocation, sonoma:        "a562978a08427740d95b3b79b77fff1390051db4fea80f7996831a100a76215d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b99b65e5f3fdb9794ff094654ebb197a4657806d6cf88de0199368efdb3a4bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d15a30e12e82b59f897f192dfc36fbcd0a6713822ec061773374ca3f46a6a9db"
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
