class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.10.17.tar.gz"
  sha256 "97cdf5c4efad72565973ce20ea6590216aa3ab6291864d40f290fb44866397bb"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "4468e6eefb3e2e6d81baa0b7a1f32e66f569027b5011472f7575853cccd515e2"
    sha256 cellar: :any_skip_relocation, all: "5dcde82468500d40e0fde89ddfb2d8e572eeccf986fa289188116c57b0a6eb3c"
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
