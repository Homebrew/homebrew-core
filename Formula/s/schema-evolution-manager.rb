class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.75.tar.gz"
  sha256 "a5f7d6d77a9abef5a4d8ba2e17b4e69d004f674bd44600969e1d24fbc12d5e66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "231218e0c1a09887959545beb447e903fb862cf2182cd77f8c374f7fe2d168a1"
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
