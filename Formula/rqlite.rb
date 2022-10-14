class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.7.2.tar.gz"
  sha256 "0f05a30ebdcb178d91895fd41b80558167f54323fe5f70c912257a189e4ed5dd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b96b5de145aee9c3838f7fbe65a10388d2cf3658e01d4dc116f241fe2e5d962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64318bce2fac34e52d7b144c7f81fbfebec85f2975e088c5b34c9eceb7fbdfb2"
    sha256 cellar: :any_skip_relocation, monterey:       "1efa517b8cae9c8223b64e6469050f47dd4f3c4b80d084d20a33b2f5013b1fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce02c66cc12d50031689782afa4a70a9a5a604ec7415298cf277a3e0c883b11b"
    sha256 cellar: :any_skip_relocation, catalina:       "516f7d981c04712e4dec14e7ba19968ebd7c1bacd6a12a093a35dd6c65a35410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e69e13bbe21362723960d5266fcc8aa31f9f2cdfe8ab5818f02a2e9abc1376"
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
