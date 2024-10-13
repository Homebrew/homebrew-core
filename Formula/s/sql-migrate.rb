class SqlMigrate < Formula
  desc "SQL schema migration tool for Go"
  homepage "https://github.com/rubenv/sql-migrate"
  url "https://github.com/rubenv/sql-migrate/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "405a405e4e6c456dfb1a11936e336866734881d735f7891e14ce9eb275688de5"
  license "MIT"
  head "https://github.com/rubenv/sql-migrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2870e77f02a2991804ddc0bcc7f26b33a91d21adf2ed85b0d2cae1374f076bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b58e698410d64d8b2e4780b39974729a09d00bab1434ce7b5c68a75f08cc472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b67c564eb19177f28740d68d95b706a46b371a1fb9dacdb0fe134f3fa2307fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26fc163f48bf785441f423f14effb740ddd5005be9733f589d13e9ec8c197080"
    sha256 cellar: :any_skip_relocation, sonoma:         "eae33d8c58f5d512c0611f03630981f399b45c44cfa552fbf2715f68730ba5a3"
    sha256 cellar: :any_skip_relocation, ventura:        "f8043567cd2b5a3ea0703772869ca47d5f265fb2afa005f1ca2f6745e998b7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "39f743ec9c8187c5b9e340fe7115a071fa7d2f01078e8814fd06aa1c9a590c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdbb3d72b87059bf10dd7f2f97d45e6ede226334c195c4f08edd381cec924b1e"
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
