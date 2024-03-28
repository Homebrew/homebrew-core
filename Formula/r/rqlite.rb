class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.23.0.tar.gz"
  sha256 "d9583bb257fa80c7924ba71dbdf3b1fa756e4fce3709983720a169f3f31736ce"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6f626549d43b7b745d88ffacfdb11a0c70ff69896283e484b8dec537c224fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de5726e3b35700066c8f3dbfeb3db088d4c7c44e57903fb70b51cd36c9bcc1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35060e73b676a3de9473395f9c0614b8f3427823f7accdc08a7df6e2c423002a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a07ee8386223ee3aec48378106b8986f05d5bfa1ee3080c37c8f38d6800ba215"
    sha256 cellar: :any_skip_relocation, ventura:        "565bb60b74d753a8f384d6e2ace04896b2e5db61b97e3c3d3492f23de99768e5"
    sha256 cellar: :any_skip_relocation, monterey:       "d8dac9d7722ea1a6e1407d76ea7ed3335345728aeb0bf6d2f2827ab1d37aaae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c7c57fcc26e832aabf0b761ea2d235ae78546c91cebef37da5ef17515566c8"
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
