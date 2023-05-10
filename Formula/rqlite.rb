class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.17.0.tar.gz"
  sha256 "dd53d9fc2162d6eaa6007cd9010eccc8a16cd469f169ed55221fdf22735f63b5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b085f17d2ee00e984d9fad8db1b474815d67f36280475f5dc1e21fc8741acf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc72a493c0bca345326f27961b430901cfab2d3b2849400fe1375b151ccc2951"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3049b9e51656ef3299d06a81cd1cfbdd20ee474ddaeae0a0294c4fcfd259909a"
    sha256 cellar: :any_skip_relocation, ventura:        "6bbf5de3aa1374b69a18bab4a4fd189d9db707647738f390156e33cd87b739bb"
    sha256 cellar: :any_skip_relocation, monterey:       "2bcd05fdb5f46537b37414ed3a534fd038faec91bfa05102b01a865327ad17a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f49ff88955fbdb59ba7c47e9e7e222be2595c56da039697017f159654283cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ec04ecfe06709a9d8a42e85dcd192f27e62e6f654de522bd006803e3f438bbf"
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
