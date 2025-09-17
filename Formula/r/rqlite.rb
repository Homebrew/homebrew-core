class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.0.2.tar.gz"
  sha256 "80bfb59fce2035b9f83c62108667b740fb4b220bee770f1895359f6abe70bee2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f97d872998a8b37fe7a4bf98f6dde2a2c3dc693c734823a5ade3dfa17dc25ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb17e868c8dd7f91616dd34f6552d5cea42d7779724ab162f01bffee0ecf94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0aac8acaeecc97cf501cad77fbe611df57ba3e420be4f87c82098506dcd5496"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d181a303a73ffd111891b9a66b39bc4885ed504f3ac81fd202d3941ae74a9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e6b96b1dd7a26281b6f513b416f89fa256b649c9b1cfc267c39d0409187e148"
  end

  depends_on "go" => :build

  def install
    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
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
