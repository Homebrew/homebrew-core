class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "88edddc02ac4bab9868651aa6a1bf18a997219693223c9f33a3a49e7c2cee553"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe8b3357b5b1d0ffe307ffe34eb23dea3e803715cb773b9d9a4fc79e0a321f3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab817f3d636fe731d76097e05b105f3112747483e6d2e052bc3862a5db175bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba0a985ad665b2aebe820caad3815c7098b0dab0520f0d418f9872ccf9b92db5"
    sha256 cellar: :any,                 arm64_linux:       "18338ab75d8fc66e09a1e17563a30087a4b38564da58ea6d12490371fe57eb42"
    sha256 cellar: :any,                 x86_64_linux:      "ab09321e6133fba997e3f1a3f37329b14247eaf521107d0890cdaa91b4d84e94"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    SQL

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end
