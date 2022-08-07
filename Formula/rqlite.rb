class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.6.1.tar.gz"
  sha256 "c618aae00c7e4e4b8abd88b46f65acf5ba31d1672f05f46b785b4e80cebfb8e3"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e60f824647b8132dc05c6a1baf48907197e35fda86fe056bd597be4783e4b748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "424844de33ccc7e8d5133ab43f55038ab1d793e5f6cb5f841f8e2fb544b57da0"
    sha256 cellar: :any_skip_relocation, monterey:       "188902e550487a320e2e3d5ddd99b964797e6ecba9b84758f9458b77266f49ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "d790895e47e677a27e14f69389eda6a3d77bafb403e5ca8377e9da37ee22856a"
    sha256 cellar: :any_skip_relocation, catalina:       "8fdd6ead9aeda06b2042a76c8fa05a2a07a635b68fbf2173652df028c857e652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0f1aa1699c1c6779d83989e9d4ad4bdb06d57591c546765a4ad83393974e6d"
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
