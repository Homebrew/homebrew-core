class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.2.0.tar.gz"
  sha256 "e6d1b31a124e8597f61b86f08b6a18168f9cd9da1db77f2a8dd1970b407b7610"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "097a7f244e8691efdffd430b3ff2d0dd79a46e41bb10cffa88ccb8a4c6f47e9e" => :mojave
    sha256 "82f04e996f0fe191fcac00acdf770c53a7a670621bb6611566491c2da2959b0b" => :high_sierra
    sha256 "3082b4691a7f14014384964472153afd5d2ac56939100be5c3a974625e412bca" => :sierra
    sha256 "5a12b8648de4c8d6693ee7fed2230ad64eb8500d6405be83db9a0f0e8bca664e" => :el_capitan
  end

  depends_on "postgresql"

  # Fix for postgresql 11 compatibility:
  # https://github.com/arkhipov/temporal_tables/issues/38
  patch do
    url "https://github.com/mlt/temporal_tables/commit/24906c44.diff?full_index=1"
    sha256 "9c20bde0bafb9cbf0fee9a4922134069e403c728660f6b9c0d6ee3ae7e48cdfc"
  end

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
