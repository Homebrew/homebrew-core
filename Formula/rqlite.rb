class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "ca0420cc2ddf6291d8fc52405dcee96c2d8da477980fcbef7aeabe855afbfeb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef0812b14332e5ded701bc4d1c51595da143f7a839a863d63b3f6f6e67fef2f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f3b849f809764cf4f0cb54510391e7e764f54b3319dbe9cdec13a2e2aa575c0"
    sha256 cellar: :any_skip_relocation, catalina:      "60b3d53623c4f2502b75fa2919904edcaed162ce7611312c41a6784c2a4c76d2"
    sha256 cellar: :any_skip_relocation, mojave:        "8bbae4f1a7bfd128b9d43a68b89f54dbd42d457bd5da21e72bf09b7cac119389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b2c85c29c97057ac742e18182c6370d39c2671e6be2a8595608bfb2b0195fa"
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
