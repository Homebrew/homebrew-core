class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "af54cd921fa8565d69bec17678d6f38c6aa062acf5eb7d68fcdf9597d6372737"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f2a605f2a643a1a90ecbffad4d6d154165c1979c1c5117ddb944b31f1e2e63e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdace6ff29f511f849ab1ce53fd777b9ca5a80cfbe99210241a8ec36c1a17356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869f270fa1afc4aab42634636fae8a4592d20ac243308914bd38c9d7ff29ab51"
    sha256 cellar: :any_skip_relocation, sonoma:        "e94ce5e532928a131273e3d6881656ee427ea6c767e8dc81d9be10efdb4ee702"
    sha256 cellar: :any,                 arm64_linux:   "10261cb0414f1838b13cda6c21cf4cb779d42cfe7208bd8d314daeefc12ddfff"
    sha256 cellar: :any,                 x86_64_linux:  "c2ae0cff4d4b15f7dfec026e4ca330e4912159128c915cc39374935eefaf9705"
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
