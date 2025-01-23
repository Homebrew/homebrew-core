class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.36.6.tar.gz"
  sha256 "b8b5c4ed87ac6f46e6bd4f2f4eecbdcd59028ecca82f4c87bba3f440045542dd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72915f58e0573ea9e7e7596e2d0dfd9314f87c850c5b0434613768b35bf1ca88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "322c90f3d214b4eef410d5dd941e183a07dc16243119066e8e6063c1e49552f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2791c85a8ea241639ed78633656d83699b0dbc3dd6db6a9f4dda426fb111c2e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "942dfd3eabe2655b67d06d60d57800471a41ff981fd76c57481b581f8a875389"
    sha256 cellar: :any_skip_relocation, ventura:       "2bac784a57e881c0b8613bc028bfe8872f4793724032ed957364f589200b34bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ad9da85c546a45f2ff0595faa5768625a35cb71f1af24563fda88d8a408b2c"
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
