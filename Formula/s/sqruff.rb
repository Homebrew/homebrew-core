class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "c2694f0cf556bea8de72e64b3805da928c336e200cf621992b213da0bdce6dfa"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a6c9ed797bfbbd3ffa6133bb0019ade5605663be5d9079df0998297a1148ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "294002a6947b6ba034a3b6cd71a3e6fc439dec853f2273f2b84edbacf0fe2501"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f78076b0d9c80c96a2ccc93880c786271cc3f3db313d2a20d250662a6aa5cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "31d318233e21e7fc67764361f0264369a6d417cdb99a4816158f949cbb2aa725"
    sha256 cellar: :any_skip_relocation, ventura:       "5174488c786c2f3cb5b55a193cd35b03a5e2e8e32ae11c8514aca24192142f2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca2f76f8b4ac13aacc7d75c68d714ec099f4e84b84577c21d3eb120fbfa3e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d72f5a591fd3c608cc29b6a8f8ce6bd7f24b67360c59b41a76ddced4532f9d"
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
