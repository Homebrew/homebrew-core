class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.20.3.tar.gz"
  sha256 "4eb572c2f209fadf458ba01fb1abb9a3f265b8def84b7a363550c099671f4772"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dd31f7ab984801f0542523464e8d54dcd628c0175b7bde447d1b17cb7c7bac4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad0260ee1cca17051e70d63589d361e7e526052d6536c62ea1433b0cd7fc72cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97e41332770677bf30cf762ac84b5f180f07772103673eab222f12a38551fa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "51db59e850814ad6d2639ece20dba30ccf217bd76e23acbc783b4368b5ce9b06"
    sha256 cellar: :any_skip_relocation, ventura:        "e56860853329a703efbd74af74dfc9503dba0b4dc213642a79ba12de56242fa8"
    sha256 cellar: :any_skip_relocation, monterey:       "e0595f06d1fb490466c8ca0454ce95a978fe72198c035287d8de7d7e9975a169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd07d790d41de78afa90bf0e956600e6183a3b66abb7722d408351411b41f5a0"
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
