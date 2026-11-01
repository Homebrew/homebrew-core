class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.63.tar.gz"
  sha256 "853ee3c85219c82be02957d34fa86ce550d82ee295611836d187dc3895941c70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac0280f20cee6d70f37a5d7d32658fc06c78d238eb03cdbbccbcfe20ee40e74c"
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
