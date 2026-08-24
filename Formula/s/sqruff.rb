class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "80bcfff3b0f4cf32c715ccfd129b006e729e1d5d7cbcdcd87118db51cd9e52ba"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d04d2e599fc7402d308450b4021a430c1585feaa28be6c0844238826dd2dfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f43f58c9d29537b464c116aafccd62d99e50d5698d0bdba9264c47ebb4ac3877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac792f5ae6d9ed836ea88680df676ea9ee767a44a050ca57aa96b5db3f726dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "724f24b7858cd79ac1f04a22513359468d9f9784f75f9b811d799de71efae2e4"
    sha256 cellar: :any,                 arm64_linux:   "253437a39de9af104ffba3a4b2622950090fbc1cfb5312206396ec87c711480a"
    sha256 cellar: :any,                 x86_64_linux:  "5ea4617191f8593fe4a75d1533b8363a614ded71e4c735e98e10cca0bdc6de1f"
  end

  depends_on "rust" => :build

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
