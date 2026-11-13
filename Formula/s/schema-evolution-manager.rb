class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.10.5.tar.gz"
  sha256 "5c804635be0223bf6a375b1af65918aeccea1ff7f1caceaf84efe712b5ff2b7f"
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
