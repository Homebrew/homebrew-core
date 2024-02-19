class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "4e64928746b5a63378b90ab80f0ff16b5dd919151cd2e22097c97950770c0054"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bd71b52cd6ff4ab994d5b6cdcbce9d37ff2454860bd411fd47d3a06d1898240"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fec7e3dcb72326470c44ffab79b3de0e50c051e1ef98cde3419fdd7c2a1eb963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632efd24fca1c2396eaa77e95c6e103909ea5c9707a91bb595b49c6543400d6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "20a256227df9a72703af079d3453e7dc82698a45d05d4260073b9fbc38c45ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "1b72b83f79d88be26dcc67fe79b8921773a90ba21eb49af6bf8814260080e49f"
    sha256 cellar: :any_skip_relocation, monterey:       "15ddf0a7f1164a90e1c098657a120eda436391037a871b7a6e9c028297fd88ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d09895fc4353171682ea869a305e5dd2b6ff6768e1b46c61c9ba91fe9ee4a4"
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
