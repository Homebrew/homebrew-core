class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.56.tar.gz"
  sha256 "f13870ead84d3f55488d30fb751f17983df0c436dc1aa483ea5dec934fbac5a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a1918862dfa68167c32ddc7dd929fd9aadb870b7d785c90c3c35967b5b0e633"
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
