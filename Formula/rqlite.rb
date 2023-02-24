class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.13.2.tar.gz"
  sha256 "acbcc7b01f52c70f697ef1745c326cfba72f583c1a5994e9da04edfec35ec647"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0839348e21be6fc4e1b5d0a1556232d881e3c8731b5986dcb70debc071109ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2569148303f27e882e92017e863dcbd211099224bb8164d2c862d09e376aa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7020d8b3185eaf99f05795d86beffb80cfb7179889f970309a8578fa5e3bbfb9"
    sha256 cellar: :any_skip_relocation, ventura:        "90d44abd6724a7f9b2828b7421a9a6ab604be2dbc10e91f23d1bceba9ad2679e"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0834de01ea70bce727231a665505064ee69f8d59600eacb2ab5441010934de"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa9b0c680516f1aae9e790ceae74aab02d5112955e6b2310b70c2675f9834b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74d37bbc317a415c292e68d8803503978385a30259d0850f00b03f2e7db17a42"
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
