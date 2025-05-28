class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.37.1.tar.gz"
  sha256 "681f9a00515c5fbc97282c47d2301e2cd6d305eac1ab48b950b96a627d50473c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5c131020ca834ac861d157a654d43748225e2fc098985d3653c70f4951c634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03a279458be0f0edcc46826b36a06fd8b9d9c12a4e2b916fa6b547735130d53e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80b183a93591401b0479040d7ee0f871553de288d468f09eddbf0ebcb3278389"
    sha256 cellar: :any_skip_relocation, sonoma:        "606bec49329e5768255374d00235947433f24401788690ddb86ad3f83f08c26e"
    sha256 cellar: :any_skip_relocation, ventura:       "02612c1d3f43ebeb4d3975e62f9eb02eb9659ff62689ba975941e393230a7e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59643d3b24f851fdf53537319a47294c9a83d406767d4559bb83d028f44c3fa0"
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
