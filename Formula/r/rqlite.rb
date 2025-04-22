class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.36.18.tar.gz"
  sha256 "c9c7c0e0b6303ba86c8982cfb1fb48d388c0b4088c3400ee010ef4daf3cc5a7c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dee1441fd88fdc277a865a4b0dddbd9410b4a613a8980857fdda96991e77fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "853bf6dab8be09c3fbbdefc5601f5745bcf5e83ac5437c6fb2d36223d1ae7d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c9a722eca777e4e4c1d931d486bf9ac63753bfe62c80e705a8c1d09ef6ff3a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a395a22381d0c2a6b9466c6a0d2f552592b7f98e03ca230f20bd0340891cc107"
    sha256 cellar: :any_skip_relocation, ventura:       "c28232ba07989a8a2a9c6e4c8cc4136c0e9cd31d8415fbe39b1a7213a54d82e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c23b1f4f4ef0d81c7bf1a0b5c3cbd7a7636071d34eb9c5f142c06ea13abdd6"
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
