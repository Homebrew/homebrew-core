class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "176a6efe0e1e402fcbc3480745779524ada35d28fd913d62f0bfcbe11e7c1a32"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae90d2799e08dbd7dc602652fce716a9c90b98fe79d8798c7245d1c5d4acef34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d163ee1f72c4460af184291b3820b7499d6d2a89b3ee92b5465135463309c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07a6acbcba1e4787a676c6e846d18fa3fb0b9364e482fb30f11149bf3a5b8adc"
    sha256 cellar: :any_skip_relocation, ventura:        "2f90a28b19801ec4cc8ecad2f612745525377f22c3c4a9492835c84a603a77c6"
    sha256 cellar: :any_skip_relocation, monterey:       "55f931a7c4d645fa9324262e90ed5e9aa3fa0677e3f6d9b0be8dc29483289293"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a2236df3f91ff46e00a955ba179c30d4f30516f1e33de8b257e8f8f80f23073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5571eda874036aef6f30b691655d24ad3dd71bdda4e95a6b69871395fd51e1c"
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
