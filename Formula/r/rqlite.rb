class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.36.11.tar.gz"
  sha256 "d985a233c1f28003c6b848bd8262dc3128d656ef9cd4917ec36294403a4f5b53"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fb928d4750307abd0b389d90f071f8157c8b075e3f1b5fd5f0c4a80e3c48a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec72868f7bd22de10fbdecdc12d2742b63f5d2f6e6e764c6506ab5945faf94c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "157351c69c210c3d3d34e698667230321cf92536c82c867162f943c8d0dfdd03"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf33b36746d27a20afe251a6417ee06b8397507231d5961a28a8b85bf0867c9"
    sha256 cellar: :any_skip_relocation, ventura:       "7b3945a6ddf7f27afc91a721486fdac26d41e905448ecb6792dc6dce351e6434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dccaf1242283f1b0a1f9d56e6cb30d97ff4d702e59e160b294158f3914789532"
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
