class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "5171e69fbb8cfd276afc3b8ac1be965cffcaa8fdc86d886d0a990b4b28bd50ad"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923aa3b54e55c95e68e4ff691541377b41dfa1a008cecb9eebe589e8677bcb37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a66dd7a7fb6162e8a649ef631d19fd95eb6bac65e575b62656d5fb18cbbdc845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3acd534137ee20e0108d79f8e5da34986b55ca27f737120fa9a6952839a0d1c"
    sha256 cellar: :any_skip_relocation, ventura:        "56f56743d5603f13a92780181d2146619543d102e0949a70a78ff02394ccf3f8"
    sha256 cellar: :any_skip_relocation, monterey:       "bf214b55a09571a24af0f991c092339051b136e913f4db00bedb78d450d57ab4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c07ec32217769ba854ec576646371de2ec5e4468152c6f3e4cd88cea33a151f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce78a4d019dd8661e74abbd7b4e433360458c954db80e595e6ec8909f83104ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X Main.Version=#{version}"), "./sql-migrate"
  end

  test do
    ENV["TZ"] = "UTC"

    test_config = testpath/"dbconfig.yml"
    test_config.write <<~EOS
      development:
        dialect: sqlite3
        datasource: test.db
        dir: migrations/sqlite3
    EOS

    mkdir testpath/"migrations/sqlite3"
    system bin/"sql-migrate", "new", "brewtest"

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    test_sql = testpath/"migrations/sqlite3/#{timestamp}-brewtest.sql"
    assert_predicate test_sql, :exist?, "failed to create test.sql"

    output = shell_output("#{bin}/sql-migrate status")
    expected = <<~EOS
      +-----------------------------+---------+
      |          MIGRATION          | APPLIED |
      +-----------------------------+---------+
      | #{timestamp}-brewtest.sql | no      |
      +-----------------------------+---------+
    EOS
    assert_equal expected, output
  end
end
