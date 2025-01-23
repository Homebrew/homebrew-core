class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "faac192e9321ce3fe2d4641a72c9ddaf6ff7c46afcbdeaa641a0027638875b3b"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d426f59baf20c63e9370b0b6de8f264a0090e4f32d7d7cf82baaa6c5d99100f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2982f036b1486b4f8fdd9a5df83eb346fd7b9363aa0cb1e72f951886074b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29bcb1522528328b56fbb468cff59dda9d752e15c381e8008d22d59e65f3ffcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2140ae10ad7bb5075063ae42e977b6702873af2e7a1b680789cbf3b40f5d81e6"
    sha256 cellar: :any_skip_relocation, ventura:       "21a74d44776d61378afc1a74476095e170c3638f51c8d0039813323ef8dd3f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151ef9df720a00cb96e49de3b31ff270716aad67eb52ad39446eec325e5b6eac"
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
