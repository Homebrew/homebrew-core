class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.24.7.tar.gz"
  sha256 "b8804e5170e7759a7521af03dd7f1a426a6d8fdcd7bf12826a674ddb0df2d4d6"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a8ea3e9d91953c357dc63b65ab507d9353ae085a91d9f24ce3d34e88521c203"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8e3031f11d927111d39fc41b2bce2eda7f33bd0b339301061c1bd282a765352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "423bafa03c67904ad4ed86a4b2c2d45be430b765a33fbe136bd6404aa44f16e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a774628b3cbf57062677d8ad75bdf9d058fd75f0d2b447ecc5cf9bb44895547a"
    sha256 cellar: :any_skip_relocation, ventura:        "e32572dbaea8880d93e718e5091f0301068b69c44f8c96a440d4eeae1dcd7403"
    sha256 cellar: :any_skip_relocation, monterey:       "b025f56df2b3e6234b03065048a98482831535f09e5252f5c4f58668296598f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45855e8e2ccdbee90786431dee7aeb3feb5d1d212d8ae66cb1895a80d04f22d8"
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
