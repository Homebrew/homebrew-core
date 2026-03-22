class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "461b813600b570acff9cf031dc6eaf996c5b52482ccc9a95380bab0a597c3517"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e74775985c88da05f258b8a93603927850ab35ac4dbe29869dcf87ad8ea4596a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a082f9c87c7caa43621a6a14ff0412b8b47739d0086eef1ead42b1af1e2a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd96ae7a83541628091b5ff0d276faae363cfe9e767154e824d1605e4a6596d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a606763e249c6d1dfc2992c46582ea35ce05059bd487058bb3d1ac10e8b8cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde3f70a007cc9957640ced5366a1140d4f3e7d03754d81b527de6d9935b4594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de0556c176c7b4c83cca6d516ebd9567e4af916b05e0a9c578343b23b6c66e0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
