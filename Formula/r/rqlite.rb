class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite.git",
    tag:      "v8.36.3",
    revision: "92bcff8e0b50570294c3d13f6b598821ad3daff6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5bb190ab32e98616d12ce57015d19d47806dc6c1213e7395b41460a6c5e75da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb4db206c68757b4a1319afeeb0807cc738e29d402dca3d49c706e04d82e859b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4fcd8c6f15bd2b1880f4172060fb6f5f06da7bdbf803193c357c5ed586df5fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "78669a1f1eba9665fcbe9ecccd89f5bf34150fa280a9ffd112dbfdb08af19d5f"
    sha256 cellar: :any_skip_relocation, ventura:       "48ab9b622a7e2522c978155b8f702201f33c6f86ab445b9cc5987dc8c54cb53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0b2af2f02b5c8548fd978563272354b81eac8f906473249cbaa213cb2bd02b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rqlite/rqlite/v8/cmd.Commit=#{Utils.git_head}
      -X github.com/rqlite/rqlite/v8/cmd.Branch=master
      -X github.com/rqlite/rqlite/v8/cmd.Buildtime=#{time.iso8601}
      -X github.com/rqlite/rqlite/v8/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
