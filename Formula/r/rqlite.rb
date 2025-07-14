class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.39.1.tar.gz"
  sha256 "e41225d146e47b94f1d4ce187c4678dd2a5fb6d5c00d3521c5af1d31aa6854f2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f446d67946f0ad825e6e4b16e5357b7171d09c8258d413efbf0bd84981f73d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "459505f06c8c005e78a8c7ead100136a75e1a3602396e943792b89157bb67647"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48bda93c30e031e5e7f72a215ef7a3ff626dd365830ed505a0521854091ce782"
    sha256 cellar: :any_skip_relocation, sonoma:        "53980a6b5306b60ce6e5aaf2b06110f5df0c2697cb94f004de7ae27a51be98a6"
    sha256 cellar: :any_skip_relocation, ventura:       "5102e903b03487a73d4f17f9ce0ac1504dfa2c8e238fd4b1d27741b400367129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "068f9baa9203170e3abb21221053c9948f38d1f4225c576693cf1dc72dbf400b"
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
