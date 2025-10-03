class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.1.2.tar.gz"
  sha256 "891a0a162366ec802fca9512a8036ffb3813e6e27e7314e6038c8af78909b9c3"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd3e1d02725a7e7c2448221feb80e18c4a3a4a82092062be3d0cb92ff3ec227e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f92af8f0c20db8a62d140e29fcf5890e435fc409dbf2249bac1b1946cd7095b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d35274363f7989ce0acd5bef1bc88c672fe1ee3aa9f92b98a0e5e694e4caf70"
    sha256 cellar: :any_skip_relocation, sonoma:        "73526305aa3f2bb58826366abe53f569bc1c410070f5adbf0916c5a58ad855a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a600b30739000005a89843e4f4e08bc371fc894f50e5f548e24623d5621d9193"
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
