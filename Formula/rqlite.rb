class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.0.1.tar.gz"
  sha256 "c4327ff869f6fd602d57c8080dfde8097d9a88b726e41e2034372bc416a78d63"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb498125a226ad68d9fa9c55cbe06d582b32d67507bdb340238600d4877ab10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef178fd693294b7ed241d46de4c14a4632d8f2bd98920b0dcc3c420799dc416"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7351f4c287fbf2c58e4b7c9558d73c05f44442e456564a89aefc81111d7368"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a972a7d2f1f436bd0bda85e70dc95b71e6afdeb62097e3dae45011396cb2a47"
    sha256 cellar: :any_skip_relocation, catalina:       "d6f6dbc6946cb5deab61dfb38e7bab7a8ddeef5494a030fe39719ea96b4a6926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcd2371c8251c72b85b8b799cc81944b27854e97893f78426ab222a0f79c79c0"
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
