class Sem < Formula
  desc "Command-line tool to manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/0.9.40.tar.gz"
  sha256 "cf5aab3f2fe81e3daca400811f46a11d4ebd25d7325eca92a83dbe0494e25d5a"

  bottle :unneeded

  def install
    system "./install.sh", prefix
  end

  test do
    assert_equal "0.9.40", shell_output("#{bin}/sem-info version").chomp
    (testpath/"new.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS test (id text);
    EOS
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end
