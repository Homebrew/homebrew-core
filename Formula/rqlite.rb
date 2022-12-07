class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.12.1.tar.gz"
  sha256 "6cca0c46b200934beb84799705c876c51438f85d2b93b0e33e9e8203991dfb59"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "908ae6e62f8fea9073cfacd5052c5bb1a0d2e45961f30b6b940c5af56204fd67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5986f608f3d6dbb4f5ce5689aa7917b08dd8caf367992247a8836351a389b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77020e74e4e10bb4e905a3ed00ae1037a388a4d25cf101d910ffbdcdee59d165"
    sha256 cellar: :any_skip_relocation, ventura:        "e5f6fc215ab33239077bec0987b919e657a6a06a742425187532830de8e88c4d"
    sha256 cellar: :any_skip_relocation, monterey:       "a8d07303f0ab032d58764924c53659546ead1f147185fc6c28aa241a2aea2cfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "351ec6a0b77628a0a187055f9daf19c808417faecd9dec6d43e05d567e813bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995fd2ae1a8d3833104950653a2640944e4c9236e6e61402461b5cd6c4f57e03"
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
