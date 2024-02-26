class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.21.3.tar.gz"
  sha256 "a28a65ba76292ffdd377613bca2cc3012a552ec46e76b4b75e38f7bef4bb965a"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b0a2fcb7fe177c9775e307e9d51c66f333730f1d8edc37adb2e13371a648e83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1274071a253f8cddd033e2ad02335e868550a1dea90e368c0e75ee1b03b1f84d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba97ddb1a1dd7fe7ef415dad248d39c640167403e95e947c76a6ded66dea17c"
    sha256 cellar: :any_skip_relocation, sonoma:         "36f79b539a5ca481d0b52c2ebfd03b59aa374c32ef26f8061a4809a2ee89598f"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb141b01a1671e4b573401845c12625b4d41956f47bb494b8b4746d9dff7df9"
    sha256 cellar: :any_skip_relocation, monterey:       "28f86c6425da85a6784b3b033c528eb0037eb8afec007467a13d71a27b99ddd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b27dc82e1c03656b6303600fddc9437348003b8ad5c1647b80ac69e0abf2599f"
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
