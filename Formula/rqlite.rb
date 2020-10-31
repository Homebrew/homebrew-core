class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.5.1.tar.gz"
  sha256 "e50e0324d10dda9be275b7faac497ce5270662966c94ea5420db6767739714ca"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb11d83162baf6772acf451ecaa2030402afbdb0f616529c211726bb711e04c0" => :catalina
    sha256 "f945e145d0de1262c4fac4c675e44a2bd7bc82db37fa97c9ed5846694978a521" => :mojave
    sha256 "c13f9b8443471bb169a9e278e541113e192847e95873daf3ce984d7e5fd6d9ea" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ["rqbench", "rqlite", "rqlited"].each do |cmd|
      system "go", "build", *std_go_args, "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
