class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.75.tar.gz"
  sha256 "a5f7d6d77a9abef5a4d8ba2e17b4e69d004f674bd44600969e1d24fbc12d5e66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2cc2fa7eb374673930279af3831e1cb3f01ce041d1cb961552dd6b5073ca58f4"
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
