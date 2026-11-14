class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.10.5.tar.gz"
  sha256 "5c804635be0223bf6a375b1af65918aeccea1ff7f1caceaf84efe712b5ff2b7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44d103ade41c0e0e894daae023355594c87da471979d7a12a477ddf0274bfd05"
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
