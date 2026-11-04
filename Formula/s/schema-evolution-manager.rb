class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.68.tar.gz"
  sha256 "726d0a0bb80d40a0f31cae45937caf315b28d45f0bf222947524ae3d8287dfea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2e49414fd04950d23a665e34b56018dcbf0e393fd7e8e64e0bd6e6ef6009ac2"
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
