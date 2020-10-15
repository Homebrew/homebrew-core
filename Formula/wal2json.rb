class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/wal2json_2_3.tar.gz"
  sha256 "2ebf71ace3c9f4b66703bcf6e3fa6ef7b6b026f9e31db4cf864eb3deb4e1a5b3"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec25d4dffbb7b4205565f2ec5ad6c17fa62a965d841a75b475b11bd7ff759c51" => :catalina
    sha256 "fbe884982b54b6d4c17a608f8f861368322cc7f74024b20516632f83ccc7fbe4" => :mojave
    sha256 "f382e783fbba2a97a79f0bda4db61211e3fbc4b5d2d859daa777ffa6845dc8ac" => :high_sierra
  end

  depends_on "postgresql"

  def install
    mkdir "stage"
    system "make", "install", "USE_PGXS=1", "DESTDIR=#{buildpath}/stage"
    lib.install Dir["stage/#{HOMEBREW_PREFIX}/lib/*"]
  end

  test do
    return if ENV["CI"]

    system "initdb", testpath/"datadir"
    mkdir testpath/"socket"
    File.open(testpath/"datadir"/"postgresql.conf", "a") do |f|
      f << "wal_level = logical\n"
      f << "listen_addresses = ''\n"
      f << "unix_socket_directories = '#{testpath}/socket'\n"
      f << "dynamic_library_path = '$libdir:#{lib}/postgresql'\n"
    end
    pid = Process.fork { exec "postgres", "-D", testpath/"datadir" }
    sleep 2
    begin
      system "createdb", "-h", testpath/"socket", "test"

      input_sql = <<~EOS
        CREATE TABLE table2_with_pk (a SERIAL, b VARCHAR(30), c TIMESTAMP NOT NULL, PRIMARY KEY(a, c));
        CREATE TABLE table2_without_pk (a SERIAL, b NUMERIC(5,2), c TEXT);

        SELECT 'init' FROM pg_create_logical_replication_slot('test_slot', 'wal2json');

        BEGIN;
        INSERT INTO table2_with_pk (b, c) VALUES('Backup and Restore', '2019-10-08 12:00:00');
        INSERT INTO table2_with_pk (b, c) VALUES('Tuning', '2019-10-08 12:00:00');
        INSERT INTO table2_with_pk (b, c) VALUES('Replication', '2019-10-08 12:00:00');
        DELETE FROM table2_with_pk WHERE a < 3;

        INSERT INTO table2_without_pk (b, c) VALUES(2.34, 'Tapir');
        -- it is not added to stream because there isn't a pk or a replica identity
        UPDATE table2_without_pk SET c = 'Anta' WHERE c = 'Tapir';
        COMMIT;

        SELECT data FROM pg_logical_slot_get_changes('test_slot', NULL, NULL, 'pretty-print', '1');
        SELECT 'stop' FROM pg_drop_replication_slot('test_slot');
      EOS

      File.open(testpath/"input.sql", "w") do |f|
        f.write(input_sql)
      end

      system "psql", "-h", testpath/"socket", "-f", testpath/"input.sql", "-o", testpath/"output.txt", "-Atq", "test"
      actual_output = File.read(testpath/"output.txt")

      expected_output = <<~EOS
        init
        {
          "change": [
            {
              "kind": "insert",
              "schema": "public",
              "table": "table2_with_pk",
              "columnnames": ["a", "b", "c"],
              "columntypes": ["integer", "character varying(30)", "timestamp without time zone"],
              "columnvalues": [1, "Backup and Restore", "2019-10-08 12:00:00"]
            }
            ,{
              "kind": "insert",
              "schema": "public",
              "table": "table2_with_pk",
              "columnnames": ["a", "b", "c"],
              "columntypes": ["integer", "character varying(30)", "timestamp without time zone"],
              "columnvalues": [2, "Tuning", "2019-10-08 12:00:00"]
            }
            ,{
              "kind": "insert",
              "schema": "public",
              "table": "table2_with_pk",
              "columnnames": ["a", "b", "c"],
              "columntypes": ["integer", "character varying(30)", "timestamp without time zone"],
              "columnvalues": [3, "Replication", "2019-10-08 12:00:00"]
            }
            ,{
              "kind": "delete",
              "schema": "public",
              "table": "table2_with_pk",
              "oldkeys": {
                "keynames": ["a", "c"],
                "keytypes": ["integer", "timestamp without time zone"],
                "keyvalues": [1, "2019-10-08 12:00:00"]
              }
            }
            ,{
              "kind": "delete",
              "schema": "public",
              "table": "table2_with_pk",
              "oldkeys": {
                "keynames": ["a", "c"],
                "keytypes": ["integer", "timestamp without time zone"],
                "keyvalues": [2, "2019-10-08 12:00:00"]
              }
            }
            ,{
              "kind": "insert",
              "schema": "public",
              "table": "table2_without_pk",
              "columnnames": ["a", "b", "c"],
              "columntypes": ["integer", "numeric(5,2)", "text"],
              "columnvalues": [1, 2.34, "Tapir"]
            }
          ]
        }
        stop
      EOS

      assert_equal(expected_output.gsub(/\s+/, ""), actual_output.gsub(/\s+/, ""))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
