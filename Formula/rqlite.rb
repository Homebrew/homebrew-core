class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.1.0.tar.gz"
  sha256 "7cd458c7c2d4aa1348a454669ff0bf251f816755b348df1f11841a023ecc4835"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b854e0fd2c91a0132b77cc5907eb7c08132086f55bcb43ca7180ae874d3ba852"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ff0f353f22e0cbbe70f1b1b050f287e6da2619d9d69c86e8acff6702b361d14"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd6d960a4badeea0c39261e1dd2badfd64edd3c72f8d1d30d5a47d2094d6fd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "067a1b48f9f2f0fd1ae1b82b2e5e25fff2a0ba7fae168bd1f91731f6a722e65b"
    sha256 cellar: :any_skip_relocation, catalina:       "71c3ebfd3803a3e4b6133447c67108884ba67aa1d405ae8359a96d6747b1e44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56753dd27274179c2182eea767441b241af6267622218bd3395ea5d6fc9fd5cd"
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
