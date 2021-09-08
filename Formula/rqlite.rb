class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.4.3.tar.gz"
  sha256 "ee34004f916cb9fad4d60199c930d1c4e7e8f5c8b2b5c55276f53b71a160f9f5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0c8767e06e2ece48938e64056255bd67fff1438637aa5fd95da533f1780bae3"
    sha256 cellar: :any_skip_relocation, big_sur:       "208dad1214feaf4c9adaaa5c225223f724bdcf493659362d0bada9ea79274cac"
    sha256 cellar: :any_skip_relocation, catalina:      "41ab5616109bb8b678d41152833517d8c4ee582386f3263d4a038e8e9230119e"
    sha256 cellar: :any_skip_relocation, mojave:        "649617599e8b890e60129bd990c59a35c9ab17d0f1e7b533d77e4d6c15b6ae78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6c9d47f535d5ff720f2e86f1355ade7c0566a6317d1ef206e2affeac6d56862"
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
