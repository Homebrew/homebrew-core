class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.72.tar.gz"
  sha256 "e0015668191da9b61e5a01f0190429ed57c43e6799144261ec899551759c106d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ab04af1e1e93d6b1f7fbe2402fd4236bcabebf1d03555121c1a91b2285cdd37"
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
