class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "1583ddfa25cb0e050788a4fc14dac5ede86eae60358337c9a5ac34b2ea059998"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ab549ab645aabbb14466bddb3eda4374fb12b7de0418b20294f7792a72d9a56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4694a98ad78b9d36a12c6d58510251f0f46e52161b8cebb171690f2e7c68ce25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693e56d035ec4b5bca30bab9b4144dc481ac87f0f87a8c928f8b69a373e37da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b400c50db746fc0037469a1306e3dc1d648afb4384100e57e520ce461616a60b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f94e0def5eea781a47f353bc4ee0daa33c238d93786a9cfa66837edcc1eb9709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc172f149f628abec76def7e4670d44fb0120d6e73b72c7bfb723592966b5fa8"
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
