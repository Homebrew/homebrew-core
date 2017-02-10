class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "http://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.1.0.tar.gz"
  sha256 "1fe210a349d1418d097f229c36f30a1daef1ff17cf0f027685171c52e366308a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "66516b4da013e96d6bf7ca098440d161a8b3f22873f1da616987ceed74951e91" => :sierra
    sha256 "6bd08ffe50a105418bcfbc5e8ef327f7662b0b5a82bffaef2b51a95e843964e3" => :el_capitan
    sha256 "64fbe7574712d243cade100240e8c7d99d1fc2b04e0d210a21caa6b86a46aadf" => :yosemite
  end

  depends_on "postgresql"

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55562"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2

      system "#{pg_bin}/createdb", "-p", pg_port, "test"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION temporal_tables;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
