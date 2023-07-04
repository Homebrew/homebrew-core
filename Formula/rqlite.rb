class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.21.2.tar.gz"
  sha256 "e1461c982f9c3a840af63e6ed383a2eff37446e0805cbfa821f984b200ec9e3f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7199566f4bdbb70f0e10d7f496350b383d4e0ea791e87c73726b69d84b6f728"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88743e10b0cdc81900c2fef6359e2e01ebd751af477354924dde332e5f460547"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7743a5f6f06e8af829a27e7397397c6b528c78bc56a3ce423429aa2307c4e902"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b5bcfe8fe43c19f0f9ecb2bc6e15e279e5386e89f9ebe1d8c419dfcfa62a0e"
    sha256 cellar: :any_skip_relocation, monterey:       "2a2da362a6c5a92a63907d08fdf1c5f107d7ca7949238636826380e596eb7f7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "caedbe1cf28eb7eeb39eb541e2e3c264e5c78177544ed82b84463fbec7f120fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a103c56ac0371e85476cd39e2d6dd37bcf63e6ddb23e12de385bd5a900ae4e71"
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
