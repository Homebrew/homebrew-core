class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "685890a086268ad8972b562f426162b19a98adbb29006074d0ea047f9ac247ad"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91ee9160faeedfc8d72fcd6a429d8a4648edc79c3133f1ba0190d9ff0de7aaf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b06d742b1aa7e9d4a71dddc120cd8711d6d51909060a507d36baf09d9c3d3b53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33390b93fc293f5302a1403952ec8ebe120526fb2d1354c8d183beb8e9308a51"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a9f3dd2e697ce4748d18a19383f261ff7a50934c654e4516b545db8179d990a"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f42a6f9f83e83de4546c40b6bf7049ed712285ec39fcbab7116a23785e502f"
    sha256 cellar: :any_skip_relocation, monterey:       "b2faa0fd60bdefdf1f629668fba64d0a7f6240b26251fe0d3160b2cdd425439c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00534ddaf6340f29b568cf8c255a18180588fccfe9bca7da587d7cb1bc5a9a8"
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
