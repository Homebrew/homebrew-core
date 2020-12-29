class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.8.0.tar.gz"
  sha256 "f24b308ce5f3256edf7f8db4f7ee1cb9d9082aa323a9b057b84dbc9aef3f03e5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "92ec353a600b27d631a5d275d41f0e632714af8ab9a4dfb57d2262621c72c977" => :big_sur
    sha256 "8d396d2ce7f6049fed7b65b0b7506a144ab012a35cb8db488a6947cacb5630da" => :arm64_big_sur
    sha256 "ba6d61e298f4535c5c079a4620fe05c20923b0ba7ee3eeb1dc43214281976148" => :catalina
    sha256 "69c26d3235b8ccf79a1cc10ef2b9600f9385e532b9e77ab693399688740b5eb2" => :mojave
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
