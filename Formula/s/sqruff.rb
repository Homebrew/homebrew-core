class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.37.3.tar.gz"
  sha256 "476671c55eeaccae6e3b8e4894cacb1ea30da54895c56e84f8c751dd04c26228"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dbad78c640a82a9a5922f89b65f2936a176c14f1c9232b9a3ae76394ac91991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9b838196ccb6d737fc556979dda2dadd5f19d08583f8583e59125f7643631e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8918a7c896b33395bc1a676e95e341027b9956b373b7ae9de4463464a3f9e65c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2791ce101d7560ac2817d1b176caf3a57039e998a0aecec376c301d541283c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c37d04fe68acd5809c53627ed1cb2884e7bcbd7729c30b1598c2e4938e3d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a7a3a969e498172737753b09915969f2a6c98b7d05f54f4e5a25eae3b3d53f"
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
