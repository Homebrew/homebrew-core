class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.37.2.tar.gz"
  sha256 "b7a06d58e6ed0a68496a18c16abc8e0b88e91e9eb2693cccf23c5ba5581d436e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d5a290e8f6e96633ef4621fafdebb1f43ce4b0adbdc48dae9d77f2c7455f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216234bfc6dba4abff14ba40a6607e84a372e5a07132059e1631fa320030755e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54f5dbe22e0d9f265d9ec5822934fea773fd25b2c14360dcd6146132079e17d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8675d18804de6d78f8dab9bb2084cd13cd0a9dd19317095f0cc3d9418dd5f227"
    sha256 cellar: :any_skip_relocation, ventura:       "b3e9b1b8e92015f8ff87fae3ea86ba69d74fef8364c40f9ce374cb44a0cf2869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26602e85a14a42e2d50f479d8ea85551cc2aee4116ea85c2cb829dc4cae7bcd6"
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
