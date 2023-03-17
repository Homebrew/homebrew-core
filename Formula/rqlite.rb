class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.14.1.tar.gz"
  sha256 "800f2b20f6ad3f536ddc448e212df08e9629919aec9624afd48b2b97552447f6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a082ad17369da594688d38b9f277084030dfa67bcc0bf95187e1487830abc9db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2f7b1606563f4ba83c33f6861561dde2ba6ecacc7097ccb9f3e58de09c97e23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72ace4c216db74f68210675f3ea0f4002d248a54d8d401ec102391d1407319ff"
    sha256 cellar: :any_skip_relocation, ventura:        "cc1a5795b8583b0b29fc8ef422bd5f3dc09fab48d4d691f44dc3fee8ba2456ce"
    sha256 cellar: :any_skip_relocation, monterey:       "f4439db81ac941cdce212e7a71a58f1b989425b9dee72395625a62022d441499"
    sha256 cellar: :any_skip_relocation, big_sur:        "afaac04cb9d1e4f4dbc9073daa976cf3e6051a79d80ec6441cdc83acf4eddae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b977bc82b206e4e180b93b6e4bc82d667c9b0b09b7b3a447dd53d847882518"
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
