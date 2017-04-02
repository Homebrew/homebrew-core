class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.1.1.tar.gz"
  sha256 "8e1496e8b04a1a8df98450710be71156d6e94d9089d31dba4e56cb156649ca45"

  bottle do
    cellar :any_skip_relocation
    sha256 "15d4d8a3f37f651f9fb2a6fffc13c3c811df861777ea4ebe12e81304f4ae24d6" => :sierra
    sha256 "149ab8a889d98d889e2ff4bd3c78356003e2f223771a62da78886d2f579bb7f1" => :el_capitan
    sha256 "02905581a3394a7de9c63b64f4f0c4dcf567fde6ca27a3f1933b9b851421dbee" => :yosemite
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
