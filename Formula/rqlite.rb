class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.3.2.tar.gz"
  sha256 "e07aa277cd60adaec45890bc4daff691c3016faa9adf9f3387fa109c229bbabe"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5772bea4340a13619379592867b42adf96678226c6b0ad1a70c673adf37354f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90ba1c08d23e3c60df2f42e9fc8d76faa88662795d3b8db80522c59c519e4933"
    sha256 cellar: :any_skip_relocation, monterey:       "72cae819389974d687655a23a5bc00bf2eb367292649b9a8e78676669e709bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f55b7dad7b0dd2fba9e07dd077d4da42f62be8e05b893e4ac117f88f834b8c8"
    sha256 cellar: :any_skip_relocation, catalina:       "90bb584acd108979ed3821513e7680d22205a14e8e2af4b1f68ff481efe0aa17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "122058eb89b9c882ccdf1f7a3fa1a5d97f60c82bf8d8a8fb85f879bc4ae2da37"
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
