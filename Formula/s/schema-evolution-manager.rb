class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.65.tar.gz"
  sha256 "24e0506ad58c90e07b3f6e68b9eb5a12efbba8ca1432e3b1a4402a7d8dd551b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e558d26ec4f89956e06303f281f8dece20cf73309192190e3edddf77496e396b"
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
