class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/0.9.45.tar.gz"
  sha256 "268a7a09a2175ed081593843fd03f330afb42710b2af0c9bc456b5e8546057c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efa86f486959f2b0c33a8e5c88c5cb4b43b64daa4cb0a6621e1ae113ef77106d"
  end

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
