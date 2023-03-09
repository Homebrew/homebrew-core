class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.14.0.tar.gz"
  sha256 "c2e4bcbd21eebe633407c8a8cede84ea1e414bd6252f311c678c8778e190bf82"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9492121e95fab9fea51232be01d3067eb6c6c7e019ec357545034e343232e37f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a92c327e8e3a1a54aad153446c4a6410c459a7004bed8c8b4b049fbbe64a5ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43b11f11304aa14dd9e85ac41d49028a034d6814dc04f0ee7051ff1ec8bdb68a"
    sha256 cellar: :any_skip_relocation, ventura:        "0203e35213045495f3a15cfa770958ec00e60d1669d250386fb9f3fb0245883f"
    sha256 cellar: :any_skip_relocation, monterey:       "4723df49d599037ed0a21273023ed86afa4658c2e2e3ea67a95ce7d29257b54f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c2fb89d3d1727083108c889a356b6d57be72bb127aa9e6b604304091bc9e892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39a4668f1cd54e50fa3d28ff9de40ae018f12aba61fc7259548d00d9e23eaf7e"
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
