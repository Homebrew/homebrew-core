class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/0.9.46.tar.gz"
  sha256 "cd6d2e46a7cbf83ba1bddb2379f88bcf509860f8f1523d2b5a9124166d4333ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4fae24c63f5b7fcb0de8a607d04769fe4251262b48c4f442480e80a7659afee2"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS test (id text);
    EOS
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end
