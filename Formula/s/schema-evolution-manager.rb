class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.61.tar.gz"
  sha256 "489fe31b6699081f52813af9e1b5b1e35e017bdaa56217c370d4e41692ea1f85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d1c6ac9fbc55712e49da72504951e7541f49ad055dd6e48845d341f73c1d446c"
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
