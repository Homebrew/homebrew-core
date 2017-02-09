class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "http://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.1.0.tar.gz"
  sha256 "1fe210a349d1418d097f229c36f30a1daef1ff17cf0f027685171c52e366308a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c1c8bb4c1530a912141c955643233d05051026c45c0b27deac021467472aa781" => :sierra
    sha256 "e0441ab106f5c10ddb866773b19f9d345d9298a1fb3e9c4f246cee99739ec405" => :el_capitan
    sha256 "701a78e5ca4cb85a0b0e2bef6ce5e18eb063a6b3fdf255aedd9070f8c09436c4" => :yosemite
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
