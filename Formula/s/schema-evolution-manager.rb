class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.66.tar.gz"
  sha256 "6f4cd10f2ed78551a9851eb54a2dd2cffaeda1172ff9bd79c6b6199bce484d74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d02dd197fa78c64386d5bd22f32035760b8edc4ecf46a0ef865f81de54a779c"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~SQL
      CREATE TABLE IF NOT EXISTS test (id text);
    SQL
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end
