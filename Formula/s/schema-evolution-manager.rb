class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.73.tar.gz"
  sha256 "aa754304a20f3cd85f9a20792fe93d9184af3cfdbcad29b01ef3a8c1f04e3cf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0d5dbad77488b1321af66fe5880c0f44f3c7b68a5dc084c95d8268d41172cf6"
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
