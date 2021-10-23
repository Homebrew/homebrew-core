class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v6.7.0.tar.gz"
  sha256 "206dd0838fafea7faaff9cfa96ad659fd65a23c5d35ed537ac5fee532c486077"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30f1544420a1f616e746a71f0ae1d946c2df13353863bd5d9f9d93066dc5c766"
    sha256 cellar: :any_skip_relocation, big_sur:       "66be40b01b406f9d10916dd78c5aaa729af93bd2e9c5a4accf0fa970685ec04a"
    sha256 cellar: :any_skip_relocation, catalina:      "22af6bfe7196d9a5a3714d470ba42be2f7c4d67f467deea92b5c2ddb26e393a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55fa039bf24b64a3e3ccb3be049903e0233a99b24f99b4e007346823f0cbc600"
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
