class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.20.4.tar.gz"
  sha256 "b5c5f83c3e276d4a0c02fdc9704aafd1c297e3a8ef794fcf889fc94bd19b9df5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8826cd592ca90de32d39ccbe0a21fec540bd6dd944d5badbcdc7c40762fadefc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "528f0dac77ce33bdf05fe501afc3d617fe22927a1f0b2e20d1d4242bc9aa3e0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f50c35a8e4d33764c996d8e68918541ee4501944e20cc973ea9ea67c69c5c16"
    sha256 cellar: :any_skip_relocation, ventura:        "5269ca04c219fdd956326158a08b7828bc2f57b54566b5b0b8b1dc1911926d3e"
    sha256 cellar: :any_skip_relocation, monterey:       "9e905da62abb99a92bd8136a7e2f6f1cc2f6bf32f9a6a4a49ff24da0bf358348"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb65cacd5699eeb54f981f8ed7a1215d773f42f6cd4a10272d50e476bb2bec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc4952473e028142e876e1c69b135029742405afbcbf97dea0c24ca467f6618"
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
