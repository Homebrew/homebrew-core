class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.36.6.tar.gz"
  sha256 "b8b5c4ed87ac6f46e6bd4f2f4eecbdcd59028ecca82f4c87bba3f440045542dd"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be2493557bde853eb4a33df2fa668fbf513476fad719bfd4543d8dc3bad7cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e9778165d09e1e6b8396df908339a9e6df57606312c64b26d41b4fc0f00027b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb7fef031cc7bd82b8867b4ddaf7900a57a6d53d3b83237f4dae29d74758e203"
    sha256 cellar: :any_skip_relocation, sonoma:        "47c04ff4b0be9cc895441df5b97d659cffc5002ea68c11d9c7fc2506be1ba84e"
    sha256 cellar: :any_skip_relocation, ventura:       "df51df157e447ebe68fb2f18fe24a23f5bc77419a3ec904ff1472130c3e731af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55cd715a9e01a3c11b687e361f1f43d669dc6028cd0f404e159670078864038"
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
