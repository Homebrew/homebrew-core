class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.1.0.tar.gz"
  sha256 "10d6308dd8370b0e705c4fbcd6bcb8a5e81121cf8ab50fd9495613893eaf0360"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3f0a52e4c81d0c9db617960e5c0ba6e006f94402632150093b7534f7ec71e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce85b9f3a93ce424f72d68e8fe046a8a262c2edcbef510ef485f0e2035738ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2623c304932c8a4b3cd0c24ec3dd9435b262fa91122932ce76ecfcc6aa7c646"
    sha256 cellar: :any_skip_relocation, sonoma:        "90954e7bf00acd442fd8efeaa7726a515fe211f46ba97d31ae821ff47b548b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88aa2945ee2f28e3d106ca2a8e85913f3eae1b2cb68fa9fd439189f3539c1669"
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
