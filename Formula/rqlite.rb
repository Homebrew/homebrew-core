class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.8.2.tar.gz"
  sha256 "51b4441b30ec0650691439e909a03715308d538e915c9d9297f88130e05955c2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197b277deab4f64b2ab8f25605d971f45a3e68375a9665a0ac292aa567d7eafc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12c9d1146d111e5f0e0060aa24046c06b50f008c5c382f76deec0fa76e027b78"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa1823e12109a8f7f181a4c52cd370f07ae49e7adbb02f17eeb040c48811f77"
    sha256 cellar: :any_skip_relocation, big_sur:        "a96370fb5d9bd889e543888a383d1fdf838950784c0ecc9c4f5523b2ac51404f"
    sha256 cellar: :any_skip_relocation, catalina:       "5f409ecf9920a50b069646d2c67ae2b746ca0c14e50d3035db2a7bfe00be8c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeb39badfa65e97d111676127afd851bf44eeb39529e4e54ecd922ac8421a52a"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
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
