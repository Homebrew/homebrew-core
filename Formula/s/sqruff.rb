class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "46142c8e031cfc8976ba24fd855fa4f2628988c15dd9eb8181e05fc130aa93f7"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094efc2bb3d75709bcdec3545c41aaeb8389374a7ae39a6f9ef8f7be5083fd56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81ba3c7f3ee198314173c2aa82396361894c897e207bff1afa58c9fef8af8f53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed65b111d721dd842a5baf67babbe6d387ea77ceaa908a76c5b80a6c61254322"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fa47732d107d63de263f66f9bf8456c5afc78cdabc63f455c28645514c8ef3e"
    sha256 cellar: :any_skip_relocation, ventura:       "ba377c26e004cbf61808468360d343f0f8602c566f5909d801570bcb46472fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e7a55b866ae61ca91723f69a254034067ca3b130c17be2d12e413704f627a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92d9cb3127674b81a5b41107f5a9cc8af3a3101472b89b299abed0c83de9ca7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end
