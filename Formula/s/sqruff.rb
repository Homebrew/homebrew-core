class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "971f32b841b390335dc707c785e1da36e7a4c91d55c3e9e37127ffe395c174ea"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf3b0aec6ada565427a6aebf13f01d9a632d7f863049c7ae912bcf324458faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692f5047ab2bd9d09ddc152930d242a7b201b82726f6836cd48d0aed239785f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b6db9f06495e20d32e6cd757473cd1e68ed0313d6143428af5a2107e05c983"
    sha256 cellar: :any_skip_relocation, sonoma:        "f57a13966078a20f9cf04a77d3bb484bdd7b3dc9a0d4dc933ced6876021dc511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fef7e202de415bc672fd62be2a3aaa0b1b5563a2941da99839781d91214d17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d5a8433dd7dd06683c604bb6faeeca5e1be81b74cc9cad6b93f8829381e212"
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
