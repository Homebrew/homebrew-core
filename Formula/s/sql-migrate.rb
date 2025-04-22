class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "692eabfc9d92f1c128381e5c637caa2f3777d16566104af67ad814db54ffddba"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5ff914e6568f81993bc2a6e53f0b775235d23726b34d40106fca5f04633ad1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a4b42f987fcf69593ea7a791317f1db869b830b0f1ef5ba548904ace4cff7ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f06914985b294e74c9e6400646f1c333e9a3f367956d24fe2c64d177c61981ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3aa4ee541144bef58833310233f640ccd26ac0354ebc9db12ac5fb561683b85"
    sha256 cellar: :any_skip_relocation, ventura:       "e3e5031ddeec22e1503488166941965ef948f5f995b7eea0a20aebb6532a8080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69670d3bfdc371986d396651fa787facbbe2f89c7618aabd061e6ebd4fb4e2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71ca31cf42b91bca6b1a920588e2cefbeb3b939f4a34c3791894ee3781affd0d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X Main.Version=#{version}"), "./sql-migrate"
  end

  test do
    ENV["TZ"] = "UTC"

    test_config = testpath/"dbconfig.yml"
    test_config.write <<~YAML
      development:
        dialect: sqlite3
        datasource: test.db
        dir: migrations/sqlite3
    YAML

    mkdir testpath/"migrations/sqlite3"
    system bin/"sql-migrate", "new", "brewtest"

    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    test_sql = testpath/"migrations/sqlite3/#{timestamp}-brewtest.sql"
    assert_path_exists test_sql, "failed to create test.sql"

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
