class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.28.4.tar.gz"
  sha256 "a44bbdbafd61392028c0bb5103eedc95495d05b063440ae641859f178b36ddaa"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f726d5ece2fce340c5066d0fcd2d2875d6cd2c3e631787a56bd10f9c6161bff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d14197f0c32dc9057110c4470456407281a9aed207a73e3dc63de9a85fbdba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc916ca2cdbb406e55de0860c0074f4a2f64ce77549148f1ab5b020e02f0c0dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "abce9d9e5409f362824f866f5756fb206051b2587f84036489eb267e8e352224"
    sha256 cellar: :any_skip_relocation, ventura:        "a380d2eddfc498da7d55e49141f7b3e1d5cf06a35859c1856bc67a962993267e"
    sha256 cellar: :any_skip_relocation, monterey:       "42f55625e97d36e939d5aa0e14d76633068ccd0e2347722c8f646ed8aa159e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701f2813803b3cd03dcc6ed5aa737674aeb39587d8fa9a1260cd96f1c3e46556"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
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

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
