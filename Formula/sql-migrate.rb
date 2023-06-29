class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "ab82def96923d9a7593229a47b285beb71d516d74620c47bef1dbf19d1ed9812"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d3cce7d65e65626e690341320dc0f97a592c06e4388df620991cca96d4fd9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c959487fb99c413b9250048dd754d845c24dc6baa202a0c300bb9a8ea3d9330"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7e2a47610c633ccc17062d189c95844c1ff04b942bccdbfc41a13d41a41b264"
    sha256 cellar: :any_skip_relocation, ventura:        "d5dc5e8ed9537aeaf5f7c6aff68a7d2037e856c67be6f4c0b531d6ab85668f50"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d1d92cfacdf9095d065794504bb7b0e854477484a5b2dedde042ed993d120b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0975d652429c54d9f1f7433a722c23f272e903c681bcfafbbb3f2f928f873893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a2f8989f3f765ba28b680a5e16a1d0e4a1eb7a3b87384d47226d97bc7e9666"
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
