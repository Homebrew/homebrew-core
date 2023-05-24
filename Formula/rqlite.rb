class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.19.0.tar.gz"
  sha256 "b5f1d2946c753ce14d0a58584fb8c8a5df10ad8dabb4bd89950a353dea8628ea"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d8b79bbdbbe8bbf0a8b5f105f2fd086e9317bfa3a80b1f0093004f7d761d2e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "108310db4106faf1987df1dcc8bdaa20bf04426a656cde3891b9865b4c4bdd71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dffa8a298f2416f7f5912233fd1aa93ea6fdfcd58f8e8c04edc3b1681fc9ffd"
    sha256 cellar: :any_skip_relocation, ventura:        "3350edf79c0522c1be73bafae42bf7f772b15644caa618d88ae430baa05e745b"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcbd7e7bf0b9c0e6024f1dc2aa27fe043addbdb609909ebc0df7bc49310c09a"
    sha256 cellar: :any_skip_relocation, big_sur:        "483d555d3f81b3a040df5abff7684b19e002418f3ab6f8a0c01a617b9e9db735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0904334c2a61469f38efbf4c8eed5130c496006f1fa4c8152498188d3c42ca07"
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
